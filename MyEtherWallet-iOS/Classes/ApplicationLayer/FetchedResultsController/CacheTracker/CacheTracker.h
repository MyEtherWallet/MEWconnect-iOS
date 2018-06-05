//
//  CacheTracker.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CacheTransactionBatch;
@class CacheRequest;
@protocol CacheTrackerDelegate;

@protocol CacheTracker <NSObject>
@property (nonatomic, weak) id <CacheTrackerDelegate> delegate;
- (void)setupWithCacheRequest:(CacheRequest *)cacheRequest;
- (void)filterResultsWithPredicate:(NSPredicate *)predicate;
- (CacheTransactionBatch *)obtainTransactionBatchFromCurrentCache;
@end

@protocol CacheTrackerDelegate <NSObject>
- (void) didProcessTransactionBatch:(CacheTransactionBatch *)transactionBatch;
@end
