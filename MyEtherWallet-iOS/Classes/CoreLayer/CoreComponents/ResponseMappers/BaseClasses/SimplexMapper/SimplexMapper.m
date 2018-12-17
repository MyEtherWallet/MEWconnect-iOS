//
//  SimplexMapper.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import EasyMapping;

#import "SimplexMapper.h"

#import "SimplexMappingProvider.h"
#import "ResponseObjectFormatter.h"
#import "NetworkingConstantsHeader.h"

@interface SimplexMapper ()
@property (nonatomic, strong) SimplexMappingProvider *provider;
@property (nonatomic, strong) id<ResponseObjectFormatter> responseFormatter;
@end

@implementation SimplexMapper

#pragma mark - Initialization

- (instancetype)initWithMappingProvider:(SimplexMappingProvider *)mappingProvider
                responseObjectFormatter:(id<ResponseObjectFormatter>)responseFormatter {
  self = [super init];
  if (self) {
    _provider = mappingProvider;
    _responseFormatter = responseFormatter;
  }
  return self;
}

#pragma mark - RCFResponseMapper

- (id)mapServerResponse:(id)response
     withMappingContext:(NSDictionary *)context
                  error:(__unused NSError *__autoreleasing *)error {
  if (self.responseFormatter) {
    response = [self.responseFormatter formatServerResponse:response];
  }
  
  EKObjectMapping *mapping = [self retreiveMappingForMappingContext:context];
  
  id result = [EKMapper objectFromExternalRepresentation:response
                                             withMapping:mapping];
  
  return result;
}

#pragma mark - Helper Methods

- (EKObjectMapping *) retreiveMappingForMappingContext:(NSDictionary *)mappingContext {
  Class objectClass = NSClassFromString(mappingContext[kMappingContextModelClassKey]);
  EKObjectMapping *mapping = [self.provider mappingForModelClass:objectClass];
  return mapping;
}

#pragma mark - Debug Description

- (NSString *)debugDescription {
  return NSStringFromClass([self class]);
}

@end
