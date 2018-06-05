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
#import "MEWCrypto.h"
#import "MEWConnectCommand.h"
#import "Ponsomizer.h"

#import "CacheRequest.h"
#import "CacheTracker.h"

#import "TokenModelObject.h"

#import "HomeInteractorOutput.h"

@interface HomeInteractor ()
@property (nonatomic, strong) NSString *address;
@end

@implementation HomeInteractor

- (void)dealloc {
  [self unsubscribe];
}

#pragma mark - HomeInteractorInput

- (void) configurateWithAddress:(NSString *)address {
  self.address = address;
  CacheRequest *request = [CacheRequest requestWithPredicate:[NSPredicate predicateWithFormat:@"SELF.address != nil"]
                                             sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES]]
                                                 objectClass:[TokenModelObject class]
                                                 filterValue:nil];
  [self.cacheTracker setupWithCacheRequest:request];
  CacheTransactionBatch *initialBatch = [self.cacheTracker obtainTransactionBatchFromCurrentCache];
  [self.output didProcessCacheTransaction:initialBatch];
  
  @weakify(self);
  [self.tokensService updateTokenBalancesForAddress:address
                                     withCompletion:^(NSError *error) {
                                       if (!error) {
                                         @strongify(self);
                                         [self.output didUpdateTokens];
                                       }
                                     }];
  [self.tokensService updateEthereumBalanceForAddress:address
                                       withCompletion:^(NSError *error) {
                                         if (!error) {
                                           @strongify(self);
                                           [self.output didUpdateEthereumBalance];
                                         }
                                       }];
}

- (NSString *) obtainAddress {
  return self.address;
}

- (NSUInteger) obtainNumberOfTokens {
  return [self.tokensService obtainNumberOfTokens];
}

- (BOOL) obtainBackupStatus {
  return [self.cryptoService isBackedUp];
}

- (void)subscribe {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidConnect:) name:MEWConnectFacadeDidConnectNotification object:self.connectFacade];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidDisconnect:) name:MEWConnectFacadeDidDisconnectNotification object:self.connectFacade];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidReceiveMessage:) name:MEWConnectFacadeDidReceiveMessageNotification object:self.connectFacade];
  
}

- (void)unsubscribe {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)disconnect {
  [self.connectFacade disconnect];
}

- (BOOL)isConnected {
  return [self.connectFacade connectionStatus] == MEWConnectStatusConnected;
}

- (TokenPlainObject *)obtainEthereum {
  TokenModelObject *ethereumModel = [self.tokensService obtainEthereum];
  if (ethereumModel) {
    TokenPlainObject *ethereum = [self.ponsomizer convertObject:ethereumModel];
    return ethereum;
  }
  return nil;
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
      [self.output openMessageSignerWithMessage:command];
      break;
    }
    case MEWConnectCommandTypeSignTransaction: {
      [self.output openTransactionSignerWithMessage:command];
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

@end
