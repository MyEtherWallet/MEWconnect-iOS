//
//  CacheTransactionBatch.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CacheTransaction;
@class CacheTransactionSection;

@interface CacheTransactionBatch : NSObject
@property (strong, nonatomic, readonly) NSOrderedSet <CacheTransaction *> *insertTransactions;
@property (strong, nonatomic, readonly) NSOrderedSet <CacheTransaction *> *updateTransactions;
@property (strong, nonatomic, readonly) NSOrderedSet <CacheTransaction *> *deleteTransactions;
@property (strong, nonatomic, readonly) NSOrderedSet <CacheTransaction *> *moveTransactions;
@property (strong, nonatomic, readonly) NSOrderedSet <CacheTransactionSection *> *sections;
- (void)addTransaction:(CacheTransaction *)transaction;
- (void)addSection:(CacheTransactionSection *)section;
- (BOOL)isEmpty;
@end

