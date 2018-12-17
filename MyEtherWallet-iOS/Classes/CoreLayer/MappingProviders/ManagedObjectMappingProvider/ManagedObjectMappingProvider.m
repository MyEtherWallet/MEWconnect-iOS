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
#import "MasterTokenModelObject.h"
#import "FiatPriceModelObject.h"
#import "PurchaseHistoryModelObject.h"

#import "SimplexServiceStatusTypes.h"

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

- (EKManagedObjectMapping *) masterTokenModelObjectMapping {
  NSDictionary *properties = @{@"balance": NSStringFromSelector(@selector(balance)),
                               @"address": NSStringFromSelector(@selector(address)),
                               @"decimals": NSStringFromSelector(@selector(decimals))};
  Class entityClass = [MasterTokenModelObject class];
  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
  return [EKManagedObjectMapping mappingForEntityName:entityName
                                            withBlock:^(EKManagedObjectMapping * _Nonnull mapping) {
                                              mapping.primaryKey = NSStringFromSelector(@selector(address));
                                              [mapping mapPropertiesFromDictionary:properties];
                                            }];
}

- (EKManagedObjectMapping *) fiatPriceModelObjectMapping {
  NSDictionary *properties = @{@"quotes.USD.price": NSStringFromSelector(@selector(usdPrice))};
  Class entityClass = [FiatPriceModelObject class];
  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
  return [EKManagedObjectMapping mappingForEntityName:entityName
                                            withBlock:^(EKManagedObjectMapping * _Nonnull mapping) {
                                              [mapping mapPropertiesFromDictionary:properties];
                                              [mapping mapKeyPath:@"symbol"
                                                       toProperty:NSStringFromSelector(@selector(fromToken))
                                                   withValueBlock:[self fromParentValueBlock]];
                                            }];
}

- (EKManagedObjectMapping *) purchaseHistoryModelObjectMapping {
  NSDictionary *properties = @{@"user_id": NSStringFromSelector(@selector(userId)),
                               @"fiat_total_amount.amount": NSStringFromSelector(@selector(amount))};
  Class entityClass = [PurchaseHistoryModelObject class];
  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
  return [EKManagedObjectMapping mappingForEntityName:entityName
                                            withBlock:^(EKManagedObjectMapping * _Nonnull mapping) {
                                              mapping.primaryKey = NSStringFromSelector(@selector(userId));
                                              [mapping mapPropertiesFromDictionary:properties];
                                              [mapping mapKeyPath:@"status"
                                                       toProperty:NSStringFromSelector(@selector(status))
                                                   withValueBlock:[self simplexStatusValueBlock]];
                                            }];
}

#pragma mark - Value Blocks

- (EKManagedMappingValueBlock) fromParentValueBlock {
  return ^id(__unused NSString *key, NSString *value, NSManagedObjectContext *context) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.symbol == %@", value];
    NSArray <TokenModelObject *> *tokens = [TokenModelObject MR_findAllWithPredicate:predicate inContext:context];
    return [NSSet setWithArray:tokens];
  };
}

- (EKManagedMappingValueBlock) simplexStatusValueBlock {
  return ^id(__unused NSString *key, NSString *value, __unused NSManagedObjectContext *context) {
    SimplexServicePaymentStatusType type = SimplexServicePaymentStatusTypeFromString(value);
    if (type != SimplexServicePaymentStatusTypeUnknown) {
      return @(type);
    }
    return nil;
  };
}

@end
