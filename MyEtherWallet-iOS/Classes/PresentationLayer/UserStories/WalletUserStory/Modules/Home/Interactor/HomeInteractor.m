//
//  HomeInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "HomeInteractor.h"

#import "TokensService.h"

#import "MEWConnectFacade.h"
#import "MEWConnectFacadeConstants.h"
#import "MEWConnectCommand.h"
#import "Ponsomizer.h"
#import "BlockchainNetworkService.h"
#import "AccountsService.h"
#import "FiatPricesService.h"
#import "ReachabilityServiceDelegate.h"
#import "RateService.h"
#import "MEWwallet.h"

#import "CacheRequest.h"
#import "CacheTracker.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "MasterTokenPlainObject.h"
#import "TokenModelObject.h"

#import "HomeInteractorOutput.h"

typedef NS_OPTIONS(short, HomeInteractorUpdatingStatus) {
  HomeInteractorUpdatingStatusIdle              = 0 << 0, //0b00000
  
  HomeInteractorUpdatingStatusBalance           = 1 << 0, //0b00001
  HomeInteractorUpdatingStatusBalanceUpdating   = 1 << 2, //0b00100
  HomeInteractorUpdatingStatusBalanceReset      = 5 << 0, //0b00101
  
  HomeInteractorUpdatingStatusTokens            = 1 << 1, //0b00010
  HomeInteractorUpdatingStatusTokensUpdating    = 1 << 3, //0b01000
  HomeInteractorUpdatingStatusTokensReset       = 5 << 1, //0b01010
  
  HomeInteractorUpdatingStatusAnyUpdating       = 3 << 2, //0b01100
  
  HomeInteractorUpdatingStatusFiatUpdating      = 1 << 4, //0b10000
};

static NSTimeInterval kHomeInteractorDefaultRefreshBalancesTime = 900.0;

@interface HomeInteractor ()
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) MasterTokenPlainObject *masterToken;
@property (nonatomic) HomeInteractorUpdatingStatus updatingStatus;
@end

@implementation HomeInteractor {
  BOOL _configured;
}

- (instancetype) init {
  self = [super init];
  if (self) {
    [self _subscribe];
    [self _startTimer];
  }
  return self;
}

- (void) dealloc {
  [self disconnect];
  [self _unsubscribe];
  [self _stopTimer];
}

#pragma mark - HomeInteractorInput

- (void) configurate {
  if (!self.masterToken) {
    [self refreshMasterToken];
  }
  [self _reloadCacheRequest];
  [self reloadData];
  _configured = YES;
}

- (void) reloadData {
  if (!self.masterToken) {
    [self refreshMasterToken];
    return;
  }
  [self _startTimer];
  [self _updateMasterBalance];
  [self _updateTokensBalance];
}

- (void) refreshMasterToken {
  MasterTokenModelObject *masterTokenModelObject = [self.tokensService obtainActiveMasterToken];
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(tokens)),
                                  NSStringFromSelector(@selector(purchaseHistory))];
  MasterTokenPlainObject *masterToken = [self.ponsomizer convertObject:masterTokenModelObject ignoringProperties:ignoringProperties];
  BOOL refreshCacheRequest = self.masterToken && !([masterToken isEqualToMasterToken:self.masterToken]);
  self.masterToken = masterToken;
  if (refreshCacheRequest) {
    [self _reloadCacheRequest];
  }
}

- (AccountPlainObject *)obtainAccount {
  return self.masterToken.fromNetworkMaster.fromAccount;
}

- (NetworkPlainObject *)obtainNetwork {
  return self.masterToken.fromNetworkMaster;
}

- (MasterTokenPlainObject *)obtainMasterToken {
  return self.masterToken;
}

- (NSUInteger) obtainNumberOfTokens {
  return [self.tokensService obtainNumberOfTokensOfMasterToken:[self obtainMasterToken]];
}

- (NSDecimalNumber *) obtainTotalPriceOfTokens {
  return [self.tokensService obtainTokensTotalPriceOfMasterToken:[self obtainMasterToken]];
}

- (void) searchTokensWithTerm:(NSString *)term {
  if ([term length] > 0) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.name contains[cd] %@ || SELF.symbol contains[cd] %@) && SELF.address != nil && SELF.fromNetwork.master.address == %@", term, term, [self obtainMasterToken].address];
    [self.cacheTracker filterResultsWithPredicate:predicate];
  } else {
    [self.cacheTracker filterResultsWithPredicate:[NSPredicate predicateWithFormat:@"SELF.address != nil && SELF.fromNetwork.master.address == %@", [self obtainMasterToken].address]];
  }
  CacheTransactionBatch *searchBatch = [self.cacheTracker obtainTransactionBatchFromCurrentCache];
  [self.output didProcessCacheTransaction:searchBatch];
}

- (void) disconnect {
  [self.connectFacade disconnect];
}

- (BOOL) isConnected {
  return [self.connectFacade connectionStatus] == MEWConnectStatusConnected;
}

- (void) refreshTokens {
  [self _updateTokensBalance];
}

- (void)selectMainnetNetwork {
  AccountModelObject *accountModelObject = [self.accountsService obtainAccountWithAccount:[self obtainAccount]];
  NSArray <NSString *> *ignoringProperties = @[NSStringFromSelector(@selector(master)),
                                               NSStringFromSelector(@selector(fromAccount)),
                                               NSStringFromSelector(@selector(tokens))];
  AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
  
  NetworkPlainObject *network = [account networkForNetworkType:BlockchainNetworkTypeMainnet];
  if (network && ![network.active boolValue]) {
    [self.blockchainNetworkService selectNetwork:network inAccount:account];
    [self.output networkDidChanged];
  }
}

- (void) selectRopstenNetwork {
  AccountModelObject *accountModelObject = [self.accountsService obtainAccountWithAccount:[self obtainAccount]];
  NSArray <NSString *> *ignoringProperties = @[NSStringFromSelector(@selector(master)),
                                               NSStringFromSelector(@selector(fromAccount)),
                                               NSStringFromSelector(@selector(tokens))];
  AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
  NetworkPlainObject *network = [account networkForNetworkType:BlockchainNetworkTypeRopsten];
  if (!network) {
    [self.output passwordIsNeededWithAccount:account];
  } else if (![network.active boolValue]) {
    [self.blockchainNetworkService selectNetwork:network inAccount:account];
    [self.output networkDidChanged];
  }
}

- (void) generateMissedKeysWithPassword:(NSString *)password {
  AccountModelObject *accountModelObject = [self.accountsService obtainAccountWithAccount:[self obtainAccount]];
  NSArray <NSString *> *ignoringProperties = @[NSStringFromSelector(@selector(fromAccount)),
                                               NSStringFromSelector(@selector(tokens)),
                                               NSStringFromSelector(@selector(price)),
                                               NSStringFromSelector(@selector(purchaseHistory))];
  AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
  if ([self.walletService isSeedAvailableForAccount:account]) {
    NSSet *chainIDs = [NSSet setWithObjects:@(BlockchainNetworkTypeRopsten), nil];
    
    @weakify(self);
    [self.walletService createKeysWithChainIDs:chainIDs
                                    forAccount:account
                                  withPassword:password
                                 mnemonicWords:nil
                                    completion:^(__unused BOOL success) {
                                      @strongify(self);
                                      [self selectRopstenNetwork];
                                    }];
  } else {
    [self.output seedIsNeededWithAccount:account password:password];
  }
}

- (void) transactionDidSigned {
  [self.rateService transactionSigned];
}

- (void) requestRaterIfNeeded {
  [self.rateService requestReviewIfNeeded];
}

#pragma mark - Notifications

- (void) MEWConnectDidConnect:(__unused NSNotification *)notification {
  [self.output mewConnectionStatusChanged];
}

- (void) MEWConnectDidDisconnect:(__unused NSNotification *)notification {
  [self.output mewConnectionStatusChanged];
}

- (void) MEWConnectDidReceiveMessage:(NSNotification *)notification {
  MEWConnectCommand *command = notification.userInfo[kMEWConnectFacadeMessage];
  switch (command.type) {
    case MEWConnectCommandTypeSignMessage: {
      [self.output openMessageSignerWithMessage:command masterToken:[self obtainMasterToken]];
      break;
    }
    case MEWConnectCommandTypeSignTransaction: {
      [self.output openTransactionSignerWithMessage:command masterToken:[self obtainMasterToken]];
      break;
    }
      
    default:
      break;
  }
}

#pragma mark - CacheTrackerDelegate

- (void) didProcessTransactionBatch:(CacheTransactionBatch *)transactionBatch {
  [self.output didProcessCacheTransaction:transactionBatch];
}

#pragma mark - Override

- (void)setUpdatingStatus:(HomeInteractorUpdatingStatus)updatingStatus {
  if (_updatingStatus == HomeInteractorUpdatingStatusIdle && updatingStatus != HomeInteractorUpdatingStatusIdle) {
    [self.output balancesDidStartUpdating];
  } else if (_updatingStatus != HomeInteractorUpdatingStatusIdle && updatingStatus == HomeInteractorUpdatingStatusIdle) {
    [self.output balancesDidEndUpdating];
  }
  
  _updatingStatus = updatingStatus;
}

#pragma mark - Private

- (void) _reloadCacheRequest {
  CacheRequest *request = [CacheRequest requestWithPredicate:[NSPredicate predicateWithFormat:@"SELF.address != nil && SELF.fromNetwork.master.address == %@", [self obtainMasterToken].address]
                                             sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]]
                                                 objectClass:[TokenModelObject class]
                                                 filterValue:nil
                                          ignoringProperties:@[NSStringFromSelector(@selector(fromAccount))]];
  [self.cacheTracker setupWithCacheRequest:request];
  CacheTransactionBatch *initialBatch = [self.cacheTracker obtainTransactionBatchFromCurrentCache];
  [self.output didProcessCacheTransaction:initialBatch];
}

- (void) _subscribe {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidConnect:) name:MEWConnectFacadeDidConnectNotification object:self.connectFacade];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidDisconnect:) name:MEWConnectFacadeDidDisconnectNotification object:self.connectFacade];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidReceiveMessage:) name:MEWConnectFacadeDidReceiveMessageNotification object:self.connectFacade];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) _unsubscribe {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) _startTimer {
  [self _stopTimer];
  self.updateTimer = [NSTimer timerWithTimeInterval:kHomeInteractorDefaultRefreshBalancesTime target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
}

- (void) _stopTimer {
  if (self.updateTimer) {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
  }
}

- (void) _updateMasterBalance {
  if ((self.updatingStatus & HomeInteractorUpdatingStatusBalance) != HomeInteractorUpdatingStatusBalance) {
    self.updatingStatus |= HomeInteractorUpdatingStatusBalance;
    self.updatingStatus |= HomeInteractorUpdatingStatusBalanceUpdating;
    @weakify(self);
    [self.tokensService updateBalanceOfMasterToken:[self obtainMasterToken]
                                    withCompletion:^(NSError *error) {
                                      @strongify(self);
                                      if (!error) {
                                        self.updatingStatus &= ~HomeInteractorUpdatingStatusBalanceUpdating;
                                        [self.output didUpdateEthereumBalance];
                                      } else {
                                        self.updatingStatus &= ~HomeInteractorUpdatingStatusBalanceReset;
                                      }
                                      if ((self.updatingStatus & HomeInteractorUpdatingStatusAnyUpdating) == HomeInteractorUpdatingStatusIdle) {
                                        [self _updateFiatPrices];
                                      }
                                    }];
  }
}

- (void) _updateTokensBalance {
  if ((self.updatingStatus & HomeInteractorUpdatingStatusTokens) != HomeInteractorUpdatingStatusTokens) {
    self.updatingStatus |= HomeInteractorUpdatingStatusTokens;
    self.updatingStatus |= HomeInteractorUpdatingStatusTokensUpdating;
    @weakify(self);
    [self.tokensService updateTokenBalancesOfMasterToken:[self obtainMasterToken]
                                          withCompletion:^(NSError *error) {
                                            @strongify(self);
                                            if (!error) {
                                              self.updatingStatus &= ~HomeInteractorUpdatingStatusTokensUpdating;
                                              [self.output didUpdateTokens];
                                            } else {
                                              self.updatingStatus &= ~HomeInteractorUpdatingStatusTokensReset;
                                            }
                                            if ((self.updatingStatus & HomeInteractorUpdatingStatusAnyUpdating) == HomeInteractorUpdatingStatusIdle) {
                                              [self _updateFiatPrices];
                                            }
                                          }];
  }
}

- (void) _updateFiatPrices {
  @weakify(self);
  self.updatingStatus |= HomeInteractorUpdatingStatusFiatUpdating;
  [self.fiatPricesService updateFiatPricesWithCompletion:^(__unused NSError *error) {
    @strongify(self);
    self.updatingStatus &= ~HomeInteractorUpdatingStatusFiatUpdating;
    if ((self.updatingStatus & HomeInteractorUpdatingStatusBalance) == HomeInteractorUpdatingStatusBalance) {
      [self refreshMasterToken];
      [self.output didUpdateEthereumBalance];
    }
    if ((self.updatingStatus & HomeInteractorUpdatingStatusTokens) == HomeInteractorUpdatingStatusTokens) {
      [self.output didUpdateTokensBalance];
    }
    self.updatingStatus = HomeInteractorUpdatingStatusIdle;
  }];

}

#pragma mark - Notifications

- (void) _applicationDidBecomeActive:(__unused NSNotification *)notification {
  if (_configured) {
    [self reloadData];
  }
}

#pragma mark - ReachabilityServiceDelegate

- (void)reachabilityStatusDidChanged:(BOOL)isReachable {
  if (isReachable) {
    [self.output internetConnectionIsReachable];
  } else {
    [self.output internetConnectionIsUnreachable];
  }
}

@end
