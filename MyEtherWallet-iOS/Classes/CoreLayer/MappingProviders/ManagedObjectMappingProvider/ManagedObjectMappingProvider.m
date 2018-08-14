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
#import "FiatPriceModelObject.h"
#import "PurchaseHistoryModelObject.h"

#import "SimplexServiceStatusTypes.h"

static NSString *const kManagedObjectMappingProviderETH = @"ETH";

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

- (EKManagedObjectMapping *) fiatPriceModelObjectMapping {
  NSDictionary *properties = @{@"quotes.USD.price": NSStringFromSelector(@selector(usdPrice))};
  Class entityClass = [FiatPriceModelObject class];
  NSString *entityName = [self.entityNameFormatter transformToEntityNameClass:entityClass];
  return [EKManagedObjectMapping mappingForEntityName:entityName
                                            withBlock:^(EKManagedObjectMapping * _Nonnull mapping) {
                                              [mapping mapPropertiesFromDictionary:properties];
                                              [mapping mapKeyPath:@"symbol"
                                                       toProperty:NSStringFromSelector(@selector(fromParent))
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
  return ^id(NSString *key, NSString *value, NSManagedObjectContext *context) {
    if ([value isEqualToString:kManagedObjectMappingProviderETH]) {
      NSArray <AccountModelObject *> *accounts = [AccountModelObject MR_findAllInContext:context];
      return accounts;
    } else {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.symbol == %@", value];
      NSArray <TokenModelObject *> *tokens = [TokenModelObject MR_findAllWithPredicate:predicate inContext:context];
      return tokens;
    }
    return nil;
  };
}

- (EKManagedMappingValueBlock) simplexStatusValueBlock {
  return ^id(NSString *key, NSString *value, NSManagedObjectContext *context) {
    SimplexServicePaymentStatusType type = SimplexServicePaymentStatusTypeFromString(value);
    if (type != SimplexServicePaymentStatusTypeUnknown) {
      return @(type);
    }
    return nil;
  };
}

@end
