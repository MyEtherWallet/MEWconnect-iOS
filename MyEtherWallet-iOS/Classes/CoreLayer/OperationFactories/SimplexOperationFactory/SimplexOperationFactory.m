//
//  SimplexOperationFactory.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SimplexOperationFactory.h"

#import "CompoundOperationBuilderConfig.h"
#import "NetworkingConstantsHeader.h"
#import "NetworkCompoundOperationBuilder.h"

#import "RequestConfigurator.h"

#import "QueryTransformer.h"
#import "BodyTransformer.h"
#import "HeadersBuilder.h"

#import "RequestDataModel.h"

#import "SimplexQuote.h"
#import "SimplexOrder.h"

#import "SimplexPaymentQuery.h"
#import "SimplexStatusQuery.h"

#import "PurchaseHistoryModelObject.h"

#import "RequestConfiguratorsFactory.h"
#import "RequestConfigurator.h"

#import "ApplicationConstants.h"

@interface SimplexOperationFactory ()
@property (nonatomic, strong) NetworkCompoundOperationBuilder *networkOperationBuilder;
@property (nonatomic, strong) id <QueryTransformer> queryTransformer;
@property (nonatomic, strong) id <BodyTransformer> bodyTransformer;
@property (nonatomic, strong) id <HeadersBuilder> headersBuilder;
@end

@implementation SimplexOperationFactory

#pragma mark - Initialization

- (instancetype)initWithBuilder:(NetworkCompoundOperationBuilder *)builder
               queryTransformer:(id<QueryTransformer>)queryTransformer
                bodyTransformer:(id<BodyTransformer>)bodyTransformer
                 headersBuilder:(id<HeadersBuilder>)headersBuilder {
  self = [super init];
  if (self) {
    _networkOperationBuilder = builder;
    _queryTransformer = queryTransformer;
    _bodyTransformer = bodyTransformer;
    _headersBuilder = headersBuilder;
  }
  return self;
}

#pragma mark - Operations creation

- (CompoundOperationBase *) quoteWithBody:(SimplexQuoteBody *)body {
  CompoundOperationBuilderConfig *config = [[CompoundOperationBuilderConfig alloc] init];
  
  config.requestConfigurationType = RequestConfigurationSimplexAPIType;
  config.requestMethod = kHTTPMethodPOST;
  
  config.serviceName = kServiceNameQuote;
  
  config.responseDeserializationType = ResponseDeserializationJSONType;
  
  config.responseConvertingType = ResponseConvertingSimplexType;
  
  config.responseValidationType = ResponseValidationSimplexType;
  
  config.responseMappingType = ResponseMappingSimplexType;
  
  config.mappingContext = @{kMappingContextModelClassKey : NSStringFromClass([SimplexQuote class])};
  
  NSData *bodyData = [self.bodyTransformer deriveDataFromBody:body];
  NSDictionary *headers = [self.headersBuilder build];
  
  RequestDataModel *inputData = [[RequestDataModel alloc] initWithHTTPHeaderFields:headers
                                                                   queryParameters:nil
                                                                          bodyData:bodyData];
  config.inputQueueData = inputData;
  return [self.networkOperationBuilder buildCompoundOperationWithConfig:config];
}

- (CompoundOperationBase *) orderWithBody:(SimplexOrderBody *)body {
  CompoundOperationBuilderConfig *config = [[CompoundOperationBuilderConfig alloc] init];
  
  config.requestConfigurationType = RequestConfigurationSimplexAPIType;
  config.requestMethod = kHTTPMethodPOST;
  
  config.serviceName = kServiceNameOrder;
  
  config.responseDeserializationType = ResponseDeserializationJSONType;
  
  config.responseConvertingType = ResponseConvertingSimplexType;
  
  config.responseValidationType = ResponseValidationSimplexType;
  
  config.responseMappingType = ResponseMappingSimplexType;
  
  config.mappingContext = @{kMappingContextModelClassKey : NSStringFromClass([SimplexOrder class])};
  
  NSData *bodyData = [self.bodyTransformer deriveDataFromBody:body];
  NSDictionary *headers = [self.headersBuilder build];
  
  RequestDataModel *inputData = [[RequestDataModel alloc] initWithHTTPHeaderFields:headers
                                                                   queryParameters:nil
                                                                          bodyData:bodyData];
  config.inputQueueData = inputData;
  return [self.networkOperationBuilder buildCompoundOperationWithConfig:config];
}

- (CompoundOperationBase *) statusWithQuery:(SimplexStatusQuery *)query {
  CompoundOperationBuilderConfig *config = [[CompoundOperationBuilderConfig alloc] init];
  
  config.requestConfigurationType = RequestConfigurationSimplexAPIType;
  config.requestMethod = kHTTPMethodGET;
  config.serviceName = kServiceNameStatus;
  config.urlParameters = @[query.userId];
  
  config.responseDeserializationType = ResponseDeserializationJSONType;
  
  config.responseConvertingType = ResponseConvertingSimplexType;
  
  config.responseValidationType = ResponseValidationSimplexType;
  
  config.responseMappingType = ResponseMappingCoreDataType;
  
  config.mappingContext = @{kMappingContextModelClassKey : NSStringFromClass([PurchaseHistoryModelObject class])};
  
  NSDictionary *headers = [self.headersBuilder build];
  
  RequestDataModel *inputData = [[RequestDataModel alloc] initWithHTTPHeaderFields:headers
                                                                   queryParameters:nil
                                                                          bodyData:nil];
  config.inputQueueData = inputData;
  return [self.networkOperationBuilder buildCompoundOperationWithConfig:config];
}

- (NSURLRequest *) requestWithQuery:(SimplexPaymentQuery *)query {
  if (!query.postURL) {
    NSURL *url = [NSURL URLWithString:kMyEtherWalletComURL];
    return [NSURLRequest requestWithURL:url];
  }
  NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:query.postURL
                                              resolvingAgainstBaseURL:YES];
  urlComponents.path = nil;
  
  id <RequestConfigurator> requestConfigurator = [self.requestConfiguratorsFactory requestConfiguratorWithType:@(RequestConfigurationSimplexWebType) url:urlComponents.URL];
  NSDictionary *parameters = [self.queryTransformer deriveUrlParametersFromQuery:query];
  
  RequestDataModel *inputData = [[RequestDataModel alloc] initWithHTTPHeaderFields:nil
                                                                   queryParameters:parameters
                                                                          bodyData:nil];
  
  NSURLRequest *request = [requestConfigurator requestWithMethod:kHTTPMethodPOST
                                                     serviceName:query.postURL.path
                                                   urlParameters:nil
                                                requestDataModel:inputData];
  return request;
}

@end
