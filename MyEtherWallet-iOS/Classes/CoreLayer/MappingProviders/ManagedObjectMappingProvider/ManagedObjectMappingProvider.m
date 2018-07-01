//
//  ManagedObjectMappingProvider.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;
@import EasyMapping;

#import "ManagedObjectMappingProvider.h"

#import "EntityNameFormatter.h"

#import "NSString+RCFCapitalization.h"

#import "TokenModelObject.h"
#import "AccountModelObject.h"

@implementation ManagedObjectMappingProvider

- (EKManagedObjectMapping *)mappingForManagedObjectModelClass:(Class)managedObjectModelClass {
  NSString *managedObjectModelStringName = NSStringFromClass(managedObjectModelClass);
  NSString *mappingName = [NSString stringWithFormat:@"%@Mapping", managedObjectModelStringName];
  NSString *decapitalizedMappingName = [mappingName rcf_decapitalizedStringSavingCase];
  
  EKManagedObjectMapping *selectedMapping = nil;
  SEL mappingSelector = NSSelectorFromString(decapitalizedMappingName);
  if ([self respondsToSelector:mappingSelector]) {
    selectedMapping = ((EKManagedObjectMapping* (*)(id, SEL))[self methodForSelector:mappingSelector])(self, mappingSelector);
  }
  return selectedMapping;
}

#pragma mark - Mappings

- (EKManagedObjectMapping *) tokenModelObjectMapping {
  NSDictionary *properties = @{@"addr": NSStringFromSelector(@selector(address)),
                               @"balance": NSStringFromSelector(@selector(balance)),
                               @"decimals": NSStringFromSelector(@selector(decimals)),
                               @"name": NSStringFromSelector(@selector(name)),
                               @"symbol": NSStringFromSelector(@selector(symbol))};
  Class entityClass = [TokenModelObject class];
  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
  return [EKManagedObjectMapping mappingForEntityName:entityName
                                            withBlock:^(EKManagedObjectMapping * _Nonnull mapping) {
                                              [mapping mapPropertiesFromDictionary:properties];
                                            }];
}

- (EKManagedObjectMapping *) accountModelObjectMapping {
  NSDictionary *properties = @{@"balance": NSStringFromSelector(@selector(balance)),
                               @"address": NSStringFromSelector(@selector(publicAddress)),
                               @"decimals": NSStringFromSelector(@selector(decimals))};
  Class entityClass = [AccountModelObject class];
  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
  return [EKManagedObjectMapping mappingForEntityName:entityName
                                            withBlock:^(EKManagedObjectMapping * _Nonnull mapping) {
                                              mapping.primaryKey = NSStringFromSelector(@selector(publicAddress));
                                              [mapping mapPropertiesFromDictionary:properties];
                                            }];
}

@end
