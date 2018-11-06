//
//  MEWMappingProvider.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import EasyMapping;

#import "NSString+RCFCapitalization.h"

#import "MEWMappingProvider.h"

#import "MEWConnectCommand.h"
#import "MEWConnectResponse.h"

@implementation MEWMappingProvider

- (EKObjectMapping *)mappingForModelClass:(Class)modelClass {
  NSString *objectModelStringName = NSStringFromClass(modelClass);
  NSString *mappingName = [NSString stringWithFormat:@"%@Mapping", objectModelStringName];
  
  EKObjectMapping *selectedMapping = nil;
  SEL mappingSelector = NSSelectorFromString(mappingName);
  if ([self respondsToSelector:mappingSelector]) {
    selectedMapping = ((EKObjectMapping* (*)(id, SEL))[self methodForSelector:mappingSelector])(self, mappingSelector);
  }
  return selectedMapping;
}

- (EKObjectMapping *) MEWConnectCommandMapping {
  NSDictionary *properties = @{@"data": NSStringFromSelector(@selector(data))};
  Class className = [MEWConnectCommand class];
  return [EKObjectMapping mappingForClass:className
                                withBlock:^(EKObjectMapping * _Nonnull mapping) {
                                  [mapping mapPropertiesFromDictionary:properties];
                                  [mapping mapKeyPath:@"type"
                                           toProperty:NSStringFromSelector(@selector(type))
                                       withValueBlock:[self commandTypeValueBlock]];
                                }];
}

- (EKObjectMapping *) MEWConnectResponseMapping {
  NSDictionary *properties = @{@"data": NSStringFromSelector(@selector(data))};
  Class className = [MEWConnectResponse class];
  return [EKObjectMapping mappingForClass:className
                                withBlock:^(EKObjectMapping * _Nonnull mapping) {
                                  [mapping mapPropertiesFromDictionary:properties];
                                  [mapping mapKeyPath:@"type"
                                           toProperty:NSStringFromSelector(@selector(type))
                                       withValueBlock:[self commandTypeValueBlock]
                                         reverseBlock:[self commandTypeReverseBlock]];
                                }];
}

- (EKMappingValueBlock) commandTypeValueBlock {
  static NSDictionary *commandTypes;
  if (!commandTypes) {
    commandTypes = @{@"address"     : @(MEWConnectCommandTypeGetAddress),
                     @"signTx"      : @(MEWConnectCommandTypeSignTransaction),
                     @"signMessage" : @(MEWConnectCommandTypeSignMessage),
                     @"text"        : @(MEWConnectCommandTypeText)};
  }
  return ^id(__unused NSString *key, NSString *value) {
    NSNumber *type = commandTypes[value] ?: @(MEWConnectCommandTypeUnknown);
    return type;
  };
}

- (EKMappingReverseBlock) commandTypeReverseBlock {
  static NSDictionary *commandTypes;
  if (!commandTypes) {
    commandTypes = @{@(MEWConnectCommandTypeGetAddress)       : @"address",
                     @(MEWConnectCommandTypeSignTransaction)  : @"signTx",
                     @(MEWConnectCommandTypeSignMessage)      : @"signMessage",
                     @(MEWConnectCommandTypeText)             : @"text"};
  }
  return ^id(id value) {
    NSString *type = commandTypes[value] ?: @"unknown";
    return type;
  };
}

@end
