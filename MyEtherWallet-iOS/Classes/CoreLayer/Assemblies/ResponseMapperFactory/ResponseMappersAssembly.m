//
//  ResponseMappersAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ResponseMappersAssembly.h"

#import "MEWConnectResponseMapper.h"
#import "MEWMappingProvider.h"
#import "ManagedObjectMapper.h"

#import "ManagedObjectMappingProvider.h"
#import "TokensResponseObjectFormatter.h"
#import "EntityNameFormatterImplementation.h"

@implementation ResponseMappersAssembly

#pragma mark - Option Matcher

- (id<ResponseMapper>)mapperWithType:(NSNumber *)type {
  return [TyphoonDefinition withOption:type matcher:^(TyphoonOptionMatcher *matcher) {
    [matcher caseEqual:@(ResponseMappingMEWConnectType)
                   use:[self mewConnectResponseMapper]];
    [matcher caseEqual:@(ResponseMappingCoreDataType)
                   use:[self manyResponseMapper]];
  }];
}

- (id <ResponseMapper>) mewConnectResponseMapper {
  return [TyphoonDefinition withClass:[MEWConnectResponseMapper class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithMappingProvider:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[self mewConnectMappingProvider]];
    }];
  }];
}

#pragma mark - Concrete Definitions

- (id<ResponseMapper>)manyResponseMapper {
  return [TyphoonDefinition withClass:[ManagedObjectMapper class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithMappingProvider:responseObjectFormatter:entityNameFormatter:) parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self mappingProvider]];
                            [initializer injectParameterWith:[self tokensResponseObjectFormatter]];
                            [initializer injectParameterWith:[self entityNameFormatter]];
                          }];
                        }];
}

#pragma mark - Mapping Provider

- (MEWMappingProvider *) mewConnectMappingProvider {
  return [TyphoonDefinition withClass:[MEWMappingProvider class]];
}

- (ManagedObjectMappingProvider *)mappingProvider {
  return [TyphoonDefinition withClass:[ManagedObjectMappingProvider class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(entityNameFormatter)
                                                with:[self entityNameFormatter]];
                        }];
}

#pragma mark - Object formatters

- (id<ResponseObjectFormatter>)tokensResponseObjectFormatter {
  return [TyphoonDefinition withClass:[TokensResponseObjectFormatter class]];
}

#pragma mark - Helpers

- (id<EntityNameFormatter>)entityNameFormatter {
  return [TyphoonDefinition withClass:[EntityNameFormatterImplementation class]];
}

@end
