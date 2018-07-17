//
//  FiatPricesOperationFactory.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "FiatPricesOperationFactory.h"

#import "CompoundOperationBuilderConfig.h"
#import "NetworkingConstantsHeader.h"
#import "NetworkCompoundOperationBuilder.h"

#import "QueryTransformer.h"
#import "BodyTransformer.h"
#import "HeadersBuilder.h"

#import "RequestDataModel.h"

#import "FiatPriceModelObject.h"

@interface FiatPricesOperationFactory ()
@property (nonatomic, strong) NetworkCompoundOperationBuilder *networkOperationBuilder;
@property (nonatomic, strong) id <QueryTransformer> queryTransformer;
@property (nonatomic, strong) id <BodyTransformer> bodyTransformer;
@property (nonatomic, strong) id <HeadersBuilder> headersBuilder;
@end


@implementation FiatPricesOperationFactory

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

- (CompoundOperationBase *) fiatPricesWithQuery:(FiatPricesQuery *)query {
  CompoundOperationBuilderConfig *config = [[CompoundOperationBuilderConfig alloc] init];
  
  config.requestConfigurationType = RequestConfigurationTickerAPIType;
  config.requestMethod = kHTTPMethodGET;
  
  config.serviceName = kServiceNameTicker;
  
  config.responseDeserializationType = ResponseDeserializationJSONType;
  
  config.responseConvertingType = ResponseConvertingTickerType;
  
  config.responseValidationType = ResponseValidationFiatPricesType;
  
  config.responseMappingType = ResponseMappingCoreDataType;
  
  config.mappingContext = @{kMappingContextModelClassKey : NSStringFromClass([FiatPriceModelObject class])};
  
  NSDictionary *headers = [self.headersBuilder build];
  
  NSDictionary *queryParameters = [self.queryTransformer deriveUrlParametersFromQuery:query];
  
  RequestDataModel *inputData = [[RequestDataModel alloc] initWithHTTPHeaderFields:headers
                                                                   queryParameters:queryParameters
                                                                          bodyData:nil];
  config.inputQueueData = inputData;
  return [self.networkOperationBuilder buildCompoundOperationWithConfig:config];
}

@end
