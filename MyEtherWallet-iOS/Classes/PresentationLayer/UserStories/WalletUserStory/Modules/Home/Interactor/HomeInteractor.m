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

#import "CacheRequest.h"
#import "CacheTracker.h"

#import "NetworkPlainObject.h"
#import "AccountPlainObject.h"
#import "TokenModelObject.h"

#import "HomeInteractorOutput.h"

@interface HomeInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@end

@implementation HomeInteractor

- (instancetype) init {
  self = [super init];
  if (self) {
    [self _subscribe];
  }
  return self;
}

- (void) dealloc {
  [self disconnect];
  [self _unsubscribe];
}

#pragma mark - HomeInteractorInput

- (void) configurate {
  if (!self.account) {
    [self refreshAccount];
  }
  [self _reloadCacheRequest];
  [self reloadData];
}

- (void) reloadData {
  if (!self.account) {
    [self refreshAccount];
    return;
  }
  @weakify(self);
  [self.output tokensDidStartUpdating];
  [self.accountsService updateBalanceForAccount:self.account
                                withCompletion:^(NSError *error) {
                                  if (!error) {
                                    @strongify(self);
                                    [self.output didUpdateEthereumBalance];
                                    [self.fiatPricesService updatePriceForEthereumWithCompletion:^(NSError *error) {
                                      [self refreshAccount];
                                      [self.output didUpdateEthereumBalance];
                                    }];
                                  }
                                }];
  [self.tokensService updateTokenBalancesForAccount:self.account
                                     withCompletion:^(NSError *error) {
                                       if (!error) {
                                         @strongify(self);
                                         [self.output didUpdateTokens];
                                         [self.fiatPricesService updatePricesForTokensWithCompletion:^(NSError *error) {
                                           [self.output didUpdateTokensBalance];
                                           [self.output tokensDidEndUpdating];
                                         }];
                                       } else {
                                         [self.output tokensDidEndUpdating];
                                       }
                                     }];
}

- (void) refreshAccount {
  AccountModelObject *accountModelObject = [self.accountsService obtainActiveAccount];
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(tokens)),
                                  NSStringFromSelector(@selector(active)),
                                  NSStringFromSelector(@selector(accounts))];
  AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
  BOOL refreshCacheRequest = self.account && ![account isEqualToAccount:self.account];
  self.account = account;
  if (refreshCacheRequest) {
    [self _reloadCacheRequest];
  }
}

- (AccountPlainObject *) obtainAccount {
  return self.account;
}

- (NSUInteger) obtainNumberOfTokens {
  return [self.tokensService obtainNumberOfTokensForAccount:self.account];
}

- (NSDecimalNumber *) obtainTotalPriceOfTokens {
  return [self.tokensService obtainTokensTotalPriceForAccount:self.account];
}

- (void) searchTokensWithTerm:(NSString *)term {
  if ([term length] > 0) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.name contains[cd] %@ || SELF.symbol contains[cd] %@) && SELF.address != nil", term, term];
    [self.cacheTracker filterResultsWithPredicate:predicate];
  } else {
    [self.cacheTracker filterResultsWithPredicate:[NSPredicate predicateWithFormat:@"SELF.address != nil"]];
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

- (NSArray *) shareActivityItems {
  return @[self.account.publicAddress];
}

- (void) refreshTokens {
  @weakify(self);
  [self.output tokensDidStartUpdating];
  [self.tokensService updateTokenBalancesForAccount:self.account
                                     withCompletion:^(NSError *error) {
                                       if (!error) {
                                         @strongify(self);
                                         [self.output didUpdateTokens];
                                         [self.fiatPricesService updatePricesForTokensWithCompletion:^(NSError *error) {
                                           [self.output didUpdateTokensBalance];
                                           [self.output tokensDidEndUpdating];
                                         }];
                                       } else {
                                         [self.output tokensDidEndUpdating];
                                       }
                                     }];
}

- (void)selectMainnetNetwork {
  BOOL selected = [self.blockchainNetworkService selectNetwork:BlockchainNetworkTypeMainnet];
  if (selected) {
    AccountModelObject *accountModelObject = [self.accountsService obtainActiveAccount];
    if (accountModelObject) {
      [self.output networkDidChangedWithAccount];
    } else {
      [self.output networkDidChangedWithoutAccount];
    }
  }
}

- (void)selectRopstenNetwork {
  BOOL selected = [self.blockchainNetworkService selectNetwork:BlockchainNetworkTypeRopsten];
  if (selected) {
    AccountModelObject *accountModelObject = [self.accountsService obtainActiveAccount];
    if (accountModelObject) {
      [self.output networkDidChangedWithAccount];
    } else {
      [self.output networkDidChangedWithoutAccount];
    }
  }
}

#pragma mark - Notifications

- (void) MEWConnectDidConnect:(NSNotification *)notification {
  [self.output mewConnectionStatusChanged];
}

- (void) MEWConnectDidDisconnect:(NSNotification *)notification {
  [self.output mewConnectionStatusChanged];
}

- (void) MEWConnectDidReceiveMessage:(NSNotification *)notification {
  MEWConnectCommand *command = notification.userInfo[kMEWConnectFacadeMessage];
  switch (command.type) {
    case MEWConnectCommandTypeSignMessage: {
      [self.output openMessageSignerWithMessage:command account:self.account];
      break;
    }
    case MEWConnectCommandTypeSignTransaction: {
      [self.output openTransactionSignerWithMessage:command account:self.account];
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

#pragma mark - Private

- (void) _reloadCacheRequest {
  CacheRequest *request = [CacheRequest requestWithPredicate:[NSPredicate predicateWithFormat:@"SELF.fromAccount.publicAddress == %@", self.account.publicAddress]
                                             sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES]]
                                                 objectClass:[TokenModelObject class]
                                                 filterValue:nil];
  [self.cacheTracker setupWithCacheRequest:request];
  CacheTransactionBatch *initialBatch = [self.cacheTracker obtainTransactionBatchFromCurrentCache];
  [self.output didProcessCacheTransaction:initialBatch];
}

- (void) _subscribe {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidConnect:) name:MEWConnectFacadeDidConnectNotification object:self.connectFacade];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidDisconnect:) name:MEWConnectFacadeDidDisconnectNotification object:self.connectFacade];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidReceiveMessage:) name:MEWConnectFacadeDidReceiveMessageNotification object:self.connectFacade];
}

- (void) _unsubscribe {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
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
