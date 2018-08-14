//
//  NetworkCompoundOperationBuilder.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CompoundOperationBuilderConfig;
@class CompoundOperationBase;
@class OperationChainer;

@protocol RequestConfiguratorsFactory;
//@protocol RequestSignersFactory;
@protocol NetworkClientsFactory;
@protocol ResponseDeserializersFactory;
@protocol ResponseConverterFactory;
@protocol ResponseValidatorsFactory;
@protocol ResponseMappersFactory;

@interface NetworkCompoundOperationBuilder : NSObject
@property (nonatomic, strong) id<RequestConfiguratorsFactory> requestConfiguratorsFactory;
//@property (nonatomic, strong) id<RequestSignersFactory> requestSignersFactory;
@property (nonatomic, strong) id<NetworkClientsFactory> networkClientsFactory;
@property (nonatomic, strong) id<ResponseDeserializersFactory> responseDeserializersFactory;
@property (nonatomic, strong) id<ResponseConverterFactory> responseConverterFactory;
@property (nonatomic, strong) id<ResponseValidatorsFactory> responseValidatorsFactory;
@property (nonatomic, strong) id<ResponseMappersFactory> responseMappersFactory;
@property (nonatomic, strong, readonly) OperationChainer *chainer;

- (instancetype) initWithOperationChainer:(OperationChainer *)chainer;
- (CompoundOperationBase *) buildCompoundOperationWithConfig:(CompoundOperationBuilderConfig *)config;
@end
