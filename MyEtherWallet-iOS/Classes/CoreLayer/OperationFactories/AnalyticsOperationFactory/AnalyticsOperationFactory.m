//
//  AnalyticsOperationFactory.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/10/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

#import "AnalyticsOperationFactory.h"

#import "CompoundOperationBuilderConfig.h"
#import "NetworkingConstantsHeader.h"
#import "NetworkCompoundOperationBuilder.h"

#import "QueryTransformer.h"
#import "BodyTransformer.h"
#import "HeadersBuilder.h"

#import "RequestDataModel.h"

@interface AnalyticsOperationFactory ()
@property (nonatomic, strong) NetworkCompoundOperationBuilder *networkOperationBuilder;
@property (nonatomic, strong) id <QueryTransformer> queryTransformer;
@property (nonatomic, strong) id <BodyTransformer> bodyTransformer;
@property (nonatomic, strong) id <HeadersBuilder> headersBuilder;
@end


@implementation AnalyticsOperationFactory

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

- (CompoundOperationBase *) analyticsWithQuery:(AnalyticsQuery *)query body:(AnalyticsBody *)body {
  CompoundOperationBuilderConfig *config = [[CompoundOperationBuilderConfig alloc] init];
  
  config.requestConfigurationType = RequestConfigurationAnalyticsType;
  config.requestMethod = kHTTPMethodPOST;
  
  config.serviceName = kServiceNameAnalytics;
  
  config.responseDeserializationType = ResponseDeserializationDisabledType;
  
  config.responseConvertingType = ResponseConvertingDisabledType;
  
  config.responseValidationType = ResponseValidationDisabledType;
  
  config.responseMappingType = ResponseMappingDisabledType;
  
  NSDictionary *headers = [self.headersBuilder build];
  NSDictionary *queryParameters = [self.queryTransformer deriveUrlParametersFromQuery:query];
  NSData *bodyData = [self.bodyTransformer deriveDataFromBody:body];
  
  RequestDataModel *inputData = [[RequestDataModel alloc] initWithHTTPHeaderFields:headers
                                                                   queryParameters:queryParameters
                                                                          bodyData:bodyData];
  config.inputQueueData = inputData;
  return [self.networkOperationBuilder buildCompoundOperationWithConfig:config];

}

@end
