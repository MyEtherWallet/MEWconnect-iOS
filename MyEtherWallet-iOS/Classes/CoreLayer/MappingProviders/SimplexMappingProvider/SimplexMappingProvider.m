//
//  SimplexMappingProvider.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import EasyMapping;

#import "SimplexMappingProvider.h"

#import "EntityNameFormatter.h"

#import "NSString+RCFCapitalization.h"

#import "SimplexQuote.h"
#import "SimplexOrder.h"

@implementation SimplexMappingProvider

- (EKObjectMapping *)mappingForModelClass:(Class)modelClass {
  NSString *modelStringName = NSStringFromClass(modelClass);
  NSString *mappingName = [NSString stringWithFormat:@"%@Mapping", modelStringName];
  NSString *decapitalizedMappingName = [mappingName rcf_decapitalizedStringSavingCase];
  
  EKObjectMapping *selectedMapping = nil;
  SEL mappingSelector = NSSelectorFromString(decapitalizedMappingName);
  if ([self respondsToSelector:mappingSelector]) {
    selectedMapping = ((EKObjectMapping* (*)(id, SEL))[self methodForSelector:mappingSelector])(self, mappingSelector);
  }
  return selectedMapping;
}

#pragma mark - Mappings

- (EKObjectMapping *) simplexQuoteMapping {
  NSDictionary *properties = @{@"quote_id": NSStringFromSelector(@selector(quoteID)),
                               @"user_id": NSStringFromSelector(@selector(userID))};
  Class className = [SimplexQuote class];
  return [EKObjectMapping mappingForClass:className
                                withBlock:^(EKObjectMapping * _Nonnull mapping) {
                                  [mapping mapPropertiesFromDictionary:properties];
                                  [mapping mapKeyPath:@"digital_money.amount"
                                           toProperty:NSStringFromSelector(@selector(digitalAmount))
                                       withValueBlock:[self decimalNumberValueBlock]];
                                  [mapping mapKeyPath:@"fiat_money.total_amount"
                                           toProperty:NSStringFromSelector(@selector(fiatAmount))
                                       withValueBlock:[self decimalNumberValueBlock]];
                                  [mapping mapKeyPath:@"fiat_money.base_amount"
                                           toProperty:NSStringFromSelector(@selector(fiatBaseAmount))
                                       withValueBlock:[self decimalNumberValueBlock]];
                                }];
}

- (EKObjectMapping *) simplexOrderMapping {
  NSDictionary *properties = @{@"version": NSStringFromSelector(@selector(apiVersion)),
                               @"partner": NSStringFromSelector(@selector(partner)),
                               @"quote_id": NSStringFromSelector(@selector(quoteID)),
                               @"payment_id": NSStringFromSelector(@selector(paymentID)),
                               @"user_id": NSStringFromSelector(@selector(userID))};
  Class className = [SimplexOrder class];
  return [EKObjectMapping mappingForClass:className
                                withBlock:^(EKObjectMapping * _Nonnull mapping) {
                                  [mapping mapPropertiesFromDictionary:properties];                                  
                                  [mapping mapKeyPath:@"payment_post_url" toProperty:NSStringFromSelector(@selector(postURL)) withValueBlock:[self urlValueBlock]];
                                  [mapping mapKeyPath:@"return_url" toProperty:NSStringFromSelector(@selector(returnURL)) withValueBlock:[self urlValueBlock]];
                                  [mapping mapKeyPath:@"fiat_total_amount_amount"
                                           toProperty:NSStringFromSelector(@selector(fiatTotalAmount))
                                       withValueBlock:[self decimalNumberValueBlock]];
                                  [mapping mapKeyPath:@"digital_total_amount_amount"
                                           toProperty:NSStringFromSelector(@selector(digitalTotalAmount))
                                       withValueBlock:[self decimalNumberValueBlock]];
                                }];
}

#pragma mark - Value blocks

- (EKMappingValueBlock) decimalNumberValueBlock {
  return ^id(__unused NSString *key, NSNumber *value) {
    return [NSDecimalNumber decimalNumberWithDecimal:[value decimalValue]];
  };
}

- (EKMappingValueBlock) urlValueBlock {
  return ^id(__unused NSString *key, NSString *value) {
    return [NSURL URLWithString:value];
  };
}

@end
