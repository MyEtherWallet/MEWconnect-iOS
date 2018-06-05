//
//  CompoundOperationBuilderConfig.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "RequestConfigurationType.h"
//#import "RequestSigningType.h"
#import "NetworkClientType.h"
#import "ResponseDeserializationType.h"
#import "ResponseConvertingType.h"
#import "ResponseValidationType.h"
#import "ResponseMappingType.h"

typedef id(^CompoundOperationInputDataMappingBlock)(id data);

@interface CompoundOperationBuilderConfig : NSObject
// General parameters
@property (nonatomic, strong) id inputQueueData;
@property (nonatomic, copy) CompoundOperationInputDataMappingBlock inputDataMappingBlock;

// Request configuration operation parameters
@property (nonatomic, assign) RequestConfigurationType requestConfigurationType;
@property (nonatomic, assign) NSString *requestMethod;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSArray *urlParameters;

// Request signing operation parameters
//@property (nonatomic, assign) RequestSigningType requestSigningType;

// Request network client
@property (nonatomic, assign) NetworkClientType networkClientType;

// Response deserialization operation parameters
@property (nonatomic, assign) ResponseDeserializationType responseDeserializationType;

// Response converting operation parameters
@property (nonatomic, assign) ResponseConvertingType responseConvertingType;

// Validation operation parameters
@property (nonatomic, assign) ResponseValidationType responseValidationType;

// Mapping operation type
@property (nonatomic, assign) ResponseMappingType responseMappingType;
@property (nonatomic, strong) NSDictionary *mappingContext;
@end
