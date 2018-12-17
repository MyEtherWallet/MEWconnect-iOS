//
//  MEWConnectResponseMapper.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import EasyMapping.EasyMapping;

#import "NetworkingConstantsHeader.h"

#import "MEWMappingProvider.h"

#import "MEWConnectResponseMapper.h"

@implementation MEWConnectResponseMapper

- (instancetype)initWithMappingProvider:(MEWMappingProvider *)mappingProvider {
  self = [super init];
  if (self) {
    _provider = mappingProvider;
  }
  return self;
}

#pragma mark - ResponseMapper

- (id) mapServerResponse:(id)response withMappingContext:(NSDictionary *)context error:(__unused NSError *__autoreleasing *)error {
  EKObjectMapping *mapping = [self retreiveMappingForMappingContext:context];
  
  id object = [EKMapper objectFromExternalRepresentation:response
                                             withMapping:mapping];
  return object;
}

- (id) serializeResponse:(id)response withMappingContext:(NSDictionary *)context error:(__unused NSError *__autoreleasing *)error {
  EKObjectMapping *mapping = [self retreiveMappingForMappingContext:context];
  
  id serializedObject = [EKSerializer serializeObject:response
                                          withMapping:mapping];
  return serializedObject;
}

- (EKObjectMapping *) retreiveMappingForMappingContext:(NSDictionary *)mappingContext {
  Class objectClass = NSClassFromString(mappingContext[kMappingContextModelClassKey]);
  EKObjectMapping *mapping = [self.provider mappingForModelClass:objectClass];
  return mapping;
}

@end

