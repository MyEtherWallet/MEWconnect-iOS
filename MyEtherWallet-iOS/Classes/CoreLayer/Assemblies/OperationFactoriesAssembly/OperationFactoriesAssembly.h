//
//  OperationFactoriesAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Typhoon;
@import RamblerTyphoonUtils.AssemblyCollector;

@protocol RequestConfiguratorsFactory;
//@protocol RequestSignersFactory;
@protocol NetworkClientsFactory;
@protocol ResponseDeserializersFactory;
@protocol ResponseValidatorsFactory;
@protocol ResponseMappersFactory;
@protocol ResponseConverterFactory;

@class TokensOperationFactory;
@class AccountsOperationFactory;
@class FiatPricesOperationFactory;
@class SimplexOperationFactory;

@interface OperationFactoriesAssembly : TyphoonAssembly <RamblerInitialAssembly>
@property (nonatomic, strong, readonly) TyphoonAssembly <RequestConfiguratorsFactory> *requestConfiguratorsFactory;
//@property (nonatomic, strong, readonly) TyphoonAssembly <RequestSignersFactory> *requestSignersFactory;
@property (nonatomic, strong, readonly) TyphoonAssembly <NetworkClientsFactory> *networkClientsFactory;
@property (nonatomic, strong, readonly) TyphoonAssembly <ResponseDeserializersFactory> *responseDeserializersFactory;
@property (nonatomic, strong, readonly) TyphoonAssembly <ResponseValidatorsFactory> *responseValidatorsFactory;
@property (nonatomic, strong, readonly) TyphoonAssembly <ResponseMappersFactory> *responseMappersFactory;
@property (nonatomic, strong, readonly) TyphoonAssembly <ResponseConverterFactory> *responseConverterFactory;
- (TokensOperationFactory *) tokensOperationFactory;
- (FiatPricesOperationFactory *) fiatPricesOperationFactory;
- (SimplexOperationFactory *) simplexOperationFactory;
@end

