//
//  CacheTransaction.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface CacheTransaction : NSObject
@property (strong, nonatomic, readonly) id object;
@property (strong, nonatomic)           NSIndexPath *oldIndexPath;
@property (strong, nonatomic)           NSIndexPath *updatedIndexPath;
@property (strong, nonatomic, readonly) NSString *objectType;
@property (assign, nonatomic, readonly) NSFetchedResultsChangeType changeType;

+ (instancetype)transactionWithObject:(id)object
                         oldIndexPath:(NSIndexPath *)oldIndexPath
                     updatedIndexPath:(NSIndexPath *)updatedIndexPath
                           objectType:(NSString *)objectType
                           changeType:(NSUInteger)changeType;
@end
