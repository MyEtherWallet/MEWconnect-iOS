//
//  CacheRequest.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CacheRequest.h"

@implementation CacheRequest

- (instancetype) initWithPredicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors
                       objectClass:(Class)objectClass
                       filterValue:(NSString *)filterValue {
  self = [super init];
  if (self) {
    _predicate = predicate;
    _sortDescriptors = sortDescriptors;
    _objectClass = objectClass;
    _filterValue = filterValue;
  }
  return self;
}

+ (instancetype)requestWithPredicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptors
                         objectClass:(Class)objectClass
                         filterValue:(NSString *)filterValue {
  return [[[self class] alloc] initWithPredicate:predicate
                                 sortDescriptors:sortDescriptors
                                     objectClass:objectClass
                                     filterValue:filterValue];
}
@end
