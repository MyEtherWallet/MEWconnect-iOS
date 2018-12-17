//
//  CacheTransactionSection.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface CacheTransactionSection : NSObject
@property (strong, nonatomic, readonly) NSString *name;
@property (assign, nonatomic, readonly) NSFetchedResultsChangeType changeType;
@property (assign, nonatomic, readonly) NSInteger oldIndex;
@property (assign, nonatomic, readonly) NSInteger updatedIndex;
+ (instancetype) transactionSectionWithName:(NSString *)name
                                   oldIndex:(NSInteger)oldIndex
                               updatedIndex:(NSInteger)uodatedIndex
                                 changeType:(NSFetchedResultsChangeType)changeType;
@end

