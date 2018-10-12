//
//  BuyEtherHistoryInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryInteractor.h"

#import "BuyEtherHistoryInteractorOutput.h"

#import "CacheRequest.h"
#import "SimplexService.h"
#import "Ponsomizer.h"

#import "AccountPlainObject.h"
#import "PurchaseHistoryModelObject.h"
#import "PurchaseHistoryPlainObject.h"

#import "SimplexServiceStatusTypes.h"

@implementation BuyEtherHistoryInteractor

#pragma mark - BuyEtherHistoryInteractorInput

- (void) configureWithAccount:(AccountPlainObject *)account {
  NSArray <PurchaseHistoryModelObject *> *historyModels = [self.simplexService obtainHistoryForAccount:account];
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(fromAccount))];
  NSArray <PurchaseHistoryPlainObject *> *history = [self.ponsomizer convertObject:historyModels ignoringProperties:ignoringProperties];
  history = [history filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.loaded == NO"]];
  for (PurchaseHistoryPlainObject *historyItem in history) {
    [self.simplexService statusForPurchase:historyItem completion:nil];
  }
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromAccount.publicAddress == %@ && SELF.loaded == YES", account.publicAddress];
  CacheRequest *request = [CacheRequest requestWithPredicate:predicate
                                             sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(date)) ascending:NO]]
                                                 objectClass:[PurchaseHistoryModelObject class]
                                                 filterValue:nil
                                          ignoringProperties:@[NSStringFromSelector(@selector(fromAccount))]];
  [self.cacheTracker setupWithCacheRequest:request];
  CacheTransactionBatch *initialBatch = [self.cacheTracker obtainTransactionBatchFromCurrentCache];
  [self.output didProcessCacheTransactionBatch:initialBatch];
}

#pragma mark - CacheTrackerDelegate

- (void)didProcessTransactionBatch:(CacheTransactionBatch *)transactionBatch {
  [self.output didProcessCacheTransactionBatch:transactionBatch];
}

@end
