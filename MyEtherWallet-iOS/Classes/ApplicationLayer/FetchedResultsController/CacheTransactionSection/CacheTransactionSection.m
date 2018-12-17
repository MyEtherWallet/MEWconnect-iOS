//
//  CacheTransactionSection.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CacheTransactionSection.h"

@implementation CacheTransactionSection

- (instancetype) initTransactionSectionWithName:(NSString *)name
                                       oldIndex:(NSInteger)oldIndex
                                   updatedIndex:(NSInteger)updatedIndex
                                     changeType:(NSFetchedResultsChangeType)changeType {
  self = [super init];
  if (self) {
    _name = name;
    _oldIndex = oldIndex;
    _updatedIndex = updatedIndex;
    _changeType = changeType;
  }
  return self;
}

+ (instancetype) transactionSectionWithName:(NSString *)name
                                   oldIndex:(NSInteger)oldIndex
                               updatedIndex:(NSInteger)updatedIndex
                                 changeType:(NSFetchedResultsChangeType)changeType {
  return [[[self class] alloc] initTransactionSectionWithName:name
                                                     oldIndex:oldIndex
                                                 updatedIndex:updatedIndex
                                                   changeType:changeType];
}

#pragma mark - Public

- (BOOL)isEqualToCacheTransactionSection:(CacheTransactionSection *)object {
  if (!object) {
    return NO;
  }
  return [self.name isEqualToString:object.name];
}

#pragma mark - Override

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  
  if (![object isKindOfClass:[CacheTransactionSection class]]) {
    return NO;
  }
  
  return [self isEqualToCacheTransactionSection:object];
}

- (NSUInteger)hash {
  return [self.name hash];
}

@end
