//
//  CacheTransactionBatch.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CacheTransaction;

@interface CacheTransactionBatch : NSObject
@property (strong, nonatomic, readonly) NSOrderedSet *insertTransactions;
@property (strong, nonatomic, readonly) NSOrderedSet *updateTransactions;
@property (strong, nonatomic, readonly) NSOrderedSet *deleteTransactions;
@property (strong, nonatomic, readonly) NSOrderedSet *moveTransactions;
- (void)addTransaction:(CacheTransaction *)transaction;
- (BOOL)isEmpty;
@end

