//
//  ResponseMappersAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ResponseMappersAssembly.h"

#import "MEWConnectResponseMapper.h"
#import "ManagedObjectMapper.h"
#import "SimplexMapper.h"

#import "MEWMappingProvider.h"
#import "ManagedObjectMappingProvider.h"
#import "SimplexMappingProvider.h"

#import "SingleResponseObjectFormatter.h"
#import "ManyResponseObjectFormatter.h"
#import "EntityNameFormatterImplementation.h"

@implementation ResponseMappersAssembly

#pragma mark - Option Matcher

- (id<ResponseMapper>)mapperWithType:(NSNumber *)type {
  return [TyphoonDefinition withOption:type matcher:^(TyphoonOptionMatcher *matcher) {
    [matcher caseEqual:@(ResponseMappingMEWConnectType)
                   use:[self mewConnectResponseMapper]];
    [matcher caseEqual:@(ResponseMappingCoreDataType)
                   use:[self manyResponseMapper]];
    [matcher caseEqual:@(ResponseMappingSimplexType)
                   use:[self simplexMapper]];
  }];
}

#pragma mark - Concrete Definitions

- (id <ResponseMapper>) mewConnectResponseMapper {
  return [TyphoonDefinition withClass:[MEWConnectResponseMapper class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithMappingProvider:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[self mewConnectMappingProvider]];
    }];
  }];
}

- (id <ResponseMapper>) manyResponseMapper {
  return [TyphoonDefinition withClass:[ManagedObjectMapper class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithMappingProvider:responseObjectFormatter:entityNameFormatter:) parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self mappingProvider]];
                            [initializer injectParameterWith:[self manyResponseObjectFormatter]];
                            [initializer injectParameterWith:[self entityNameFormatter]];
                          }];
                        }];
}

- (id <ResponseMapper>) simplexMapper {
  return [TyphoonDefinition withClass:[SimplexMapper class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithMappingProvider:responseObjectFormatter:) parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self simplexMappingProvider]];
                            [initializer injectParameterWith:[self singleResponseObjectFormatter]];
                          }];
                        }];
}

#pragma mark - Mapping Provider

- (MEWMappingProvider *) mewConnectMappingProvider {
  return [TyphoonDefinition withClass:[MEWMappingProvider class]];
}

- (ManagedObjectMappingProvider *) mappingProvider {
  return [TyphoonDefinition withClass:[ManagedObjectMappingProvider class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(entityNameFormatter)
                                                with:[self entityNameFormatter]];
                        }];
}

- (SimplexMappingProvider *) simplexMappingProvider {
  return [TyphoonDefinition withClass:[SimplexMappingProvider class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(entityNameFormatter)
                                                with:[self entityNameFormatter]];
                        }];
}

#pragma mark - Object formatters

- (id <ResponseObjectFormatter>) singleResponseObjectFormatter {
  return [TyphoonDefinition withClass:[SingleResponseObjectFormatter class]];
}

- (id <ResponseObjectFormatter>) manyResponseObjectFormatter {
  return [TyphoonDefinition withClass:[ManyResponseObjectFormatter class]];
}

#pragma mark - Helpers

- (id<EntityNameFormatter>) entityNameFormatter {
  return [TyphoonDefinition withClass:[EntityNameFormatterImplementation class]];
}

@end
