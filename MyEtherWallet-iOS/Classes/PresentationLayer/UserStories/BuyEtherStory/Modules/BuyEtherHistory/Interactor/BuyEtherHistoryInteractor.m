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

#import "MasterTokenPlainObject.h"
#import "PurchaseHistoryModelObject.h"
#import "PurchaseHistoryPlainObject.h"

#import "SimplexServiceStatusTypes.h"

@implementation BuyEtherHistoryInteractor

#pragma mark - BuyEtherHistoryInteractorInput

- (void) configureWithMasterToken:(MasterTokenPlainObject *)masterToken {
  [self.simplexService clearCancelledHistoryForMasterToken:masterToken];
  NSArray <PurchaseHistoryModelObject *> *historyModels = [self.simplexService obtainHistoryForMasterToken:masterToken];
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(fromToken))];
  NSArray <PurchaseHistoryPlainObject *> *history = [self.ponsomizer convertObject:historyModels ignoringProperties:ignoringProperties];
  history = [history filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PurchaseHistoryPlainObject *evaluatedObject, __unused NSDictionary<NSString *,id> * _Nullable bindings) {
    return !SimplexServicePaymentStatusTypeIsFinal([evaluatedObject.status shortValue]);
  }]];
  for (PurchaseHistoryPlainObject *historyItem in history) {
    [self.simplexService statusForPurchase:historyItem completion:nil];
  }
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.fromToken.fromNetwork.master.address == %@ || SELF.fromToken.address == %@) && SELF.loaded == YES && SELF.status IN %@",
                            masterToken.address, masterToken.address, @[@(SimplexServicePaymentStatusTypeInProgress), @(SimplexServicePaymentStatusTypeApproved), @(SimplexServicePaymentStatusTypeDeclined)]];
  CacheRequest *request = [CacheRequest requestWithPredicate:predicate
                                             sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(date)) ascending:NO]]
                                                 objectClass:[PurchaseHistoryModelObject class]
                                                 filterValue:nil
                                          ignoringProperties:@[NSStringFromSelector(@selector(fromToken))]];
  [self.cacheTracker setupWithCacheRequest:request];
  CacheTransactionBatch *initialBatch = [self.cacheTracker obtainTransactionBatchFromCurrentCache];
  [self.output didProcessCacheTransactionBatch:initialBatch];
}

#pragma mark - CacheTrackerDelegate

- (void)didProcessTransactionBatch:(CacheTransactionBatch *)transactionBatch {
  [self.output didProcessCacheTransactionBatch:transactionBatch];
}

@end
