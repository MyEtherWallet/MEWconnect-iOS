//
//  NetworkCompoundOperationBuilder.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NetworkCompoundOperationBuilder.h"

#import "RequestConfigurationOperation.h"
//#import "RequestSigningOperation.h"
#import "NetworkOperation.h"
#import "ResponseDeserializationOperation.h"
#import "ResponseConverterOperation.h"
#import "ResponseValidationOperation.h"
#import "ResponseMappingOperation.h"

#import "RequestConfiguratorsFactory.h"
//#import "RequestSignersFactory.h"
#import "NetworkClientsFactory.h"
#import "ResponseDeserializersFactory.h"
#import "ResponseConverterFactory.h"
#import "ResponseValidatorsFactory.h"
#import "ResponseMappersFactory.h"

#import "ChainableOperation.h"
#import "OperationBuffer.h"
#import "OperationChainer.h"
#import "CompoundOperationBase.h"
#import "CompoundOperationBuilderConfig.h"

@interface NetworkCompoundOperationBuilder ()
@property (nonatomic, strong) NSMutableArray *operationsArray;
@property (nonatomic, strong) OperationChainer *chainer;
@end

@implementation NetworkCompoundOperationBuilder

- (instancetype)initWithOperationChainer:(OperationChainer *)chainer {
  self = [super init];
  if (self) {
    _chainer = chainer;
    _operationsArray = [NSMutableArray array];
  }
  return self;
}

#pragma mark - Building Compound operation

- (CompoundOperationBase *)buildCompoundOperationWithConfig:(CompoundOperationBuilderConfig *)config {
  NSAssert(config, @"Config shouldn't be nil");

  [self.operationsArray removeAllObjects];

  [self buildRequestConfigurationOperationWithConfig:config];
//  [self buildRequestSigningOperationWithConfig:config];
  [self buildNetworkOperationWithConfig:config];
  [self buildResponseDeserializationOperationWithConfig:config];
  [self buildResponseValidationOperationWithConfig:config];
  [self buildResponseConverterOperationWithConfig:config];
  [self buildResponseMappingOperationWithConfig:config];
  
  CompoundOperationBase *compoundOperation = [self getResultCompoundOperation];
  id inputData = config.inputQueueData;
  if (config.inputDataMappingBlock) {
    inputData = config.inputDataMappingBlock(inputData);
  }
  [compoundOperation.queueInput setOperationQueueInputData:inputData];

  return compoundOperation;
}

- (void)buildRequestConfigurationOperationWithConfig:(CompoundOperationBuilderConfig *)config {
  id<RequestConfigurator> configurator = [self.requestConfiguratorsFactory requestConfiguratorWithType:@(config.requestConfigurationType)];
  RequestConfigurationOperation *operation = [RequestConfigurationOperation operationWithRequestConfigurator:configurator method:config.requestMethod serviceName:config.serviceName urlParameters:config.urlParameters];
  [self addOperation:operation];
}

//- (void)buildRequestSigningOperationWithConfig:(CompoundOperationBuilderConfig *)config {
//  if (config.requestSigningType == RequestSigningDisabledType) {
//    return;
//  }
//  id<RequestSigner> signer = [self.requestSignersFactory requestSignerWithType:@(config.requestSigningType)];
//  RequestSigningOperation *operation = [RequestSigningOperation operationWithRequestSigner:signer];
//  [self addOperation:operation];
//}

- (void)buildNetworkOperationWithConfig:(CompoundOperationBuilderConfig *)config {
  id<NetworkClient> client = [self.networkClientsFactory networkClientWithClientType:@(config.networkClientType)];
  NetworkOperation *operation = [NetworkOperation operationWithNetworkClient:client];
  [self addOperation:operation];
}

- (void)buildResponseDeserializationOperationWithConfig:(CompoundOperationBuilderConfig *)config {
  if (config.responseDeserializationType == ResponseDeserializationDisabledType) {
    return;
  }
  id<ResponseDeserializer> deserializer = [self.responseDeserializersFactory deserializerWithType:@(config.responseDeserializationType)];
  ResponseDeserializationOperation *operation = [ResponseDeserializationOperation operationWithResponseDeserializer:deserializer];
  [self addOperation:operation];
}

- (void)buildResponseConverterOperationWithConfig:(CompoundOperationBuilderConfig *)config {
  if (config.responseConvertingType == ResponseConvertingDisabledType) {
    return;
  }
  id<ResponseConverter> converter = [self.responseConverterFactory converterWithType:@(config.responseConvertingType)];
  ResponseConverterOperation *operation = [ResponseConverterOperation operationWithResponseConverter:converter];
  [self addOperation:operation];
}

- (void)buildResponseValidationOperationWithConfig:(CompoundOperationBuilderConfig *)config {
  if (config.responseValidationType == ResponseValidationDisabledType) {
    return;
  }
  id<ResponseValidator> validator = [self.responseValidatorsFactory validatorWithType:@(config.responseValidationType)];
  ResponseValidationOperation *operation = [ResponseValidationOperation operationWithResponseValidator:validator];
  [self addOperation:operation];
}

- (void)buildResponseMappingOperationWithConfig:(CompoundOperationBuilderConfig *)config {
  if (config.responseMappingType == ResponseMappingDisabledType) {
    return;
  }
  id <ResponseMapper> mapper = [self.responseMappersFactory mapperWithType:@(config.responseMappingType)];
  ResponseMappingOperation *operation = [ResponseMappingOperation operationWithResponseMapper:mapper mappingContext:config.mappingContext];
  [self addOperation:operation];
}

#pragma mark - Processing Operations

- (void)addOperation:(NSOperation<ChainableOperation> *)operation {
  [self.operationsArray addObject:operation];
  NSUInteger operationIndex = [self.operationsArray indexOfObject:operation];

  if (operationIndex > 0)  {
    NSUInteger previousOperationIndex = operationIndex - 1;
    NSOperation <ChainableOperation> *parentOperation = self.operationsArray[previousOperationIndex];

    OperationBuffer *buffer = [OperationBuffer buffer];
    [self.chainer chainParentOperation:parentOperation
                    withChildOperation:operation
                            withBuffer:buffer];
  }
}

#pragma mark - Getting Result

- (CompoundOperationBase *)getResultCompoundOperation {
  CompoundOperationBase *compoundOperation = [CompoundOperationBase new];
  compoundOperation.maxConcurrentOperationsCount = 1;
  [self.chainer chainCompoundOperation:compoundOperation
          withChainableOperationsQueue:[self.operationsArray copy]];

  for (NSOperation <ChainableOperation> *operation in self.operationsArray) {
    [compoundOperation addOperation:operation];
    operation.delegate = compoundOperation;
  }

  return compoundOperation;
}

@end

