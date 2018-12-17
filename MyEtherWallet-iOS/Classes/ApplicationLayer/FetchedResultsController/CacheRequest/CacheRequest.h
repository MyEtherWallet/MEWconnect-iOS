//
//  CacheRequest.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface CacheRequest : NSObject
@property (nonatomic, strong, readonly) NSPredicate *predicate;
@property (nonatomic, strong, readonly) NSArray *sortDescriptors;
@property (nonatomic, assign, readonly) Class objectClass;
@property (nonatomic, strong, readonly) NSString *filterValue;
@property (nonatomic, strong, readonly) NSArray <NSString *> *ignoringProperties;
@property (nonatomic, readonly)         BOOL sections;

+ (instancetype)requestWithPredicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptors
                         objectClass:(Class)objectClass
                         filterValue:(NSString *)filterValue
                  ignoringProperties:(NSArray <NSString *> *)ignoringProperties;

+ (instancetype)requestWithPredicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptors
                         objectClass:(Class)objectClass
                         filterValue:(NSString *)filterValue
                  ignoringProperties:(NSArray <NSString *> *)ignoringProperties
                            sections:(BOOL)section;
@end
