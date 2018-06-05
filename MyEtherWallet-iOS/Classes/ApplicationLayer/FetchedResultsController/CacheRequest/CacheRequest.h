//
//  CacheRequest.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface CacheRequest : NSObject
@property (strong, nonatomic, readonly) NSPredicate *predicate;
@property (strong, nonatomic, readonly) NSArray *sortDescriptors;
@property (assign, nonatomic, readonly) Class objectClass;
@property (strong, nonatomic, readonly) NSString *filterValue;

+ (instancetype)requestWithPredicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptors
                         objectClass:(Class)objectClass
                         filterValue:(NSString *)filterValue;
@end
