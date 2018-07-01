//
//  OperationFactoriesAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "OperationFactoriesAssembly.h"

#import "NetworkCompoundOperationBuilder.h"
#import "OperationChainer.h"

#import "QueryTransformerBase.h"

#import "ContractsBodyTransformer.h"
#import "BalanceBodyTransformer.h"

#import "HeadersBuilderBase.h"

#import "TokensOperationFactory.h"
#import "AccountsOperationFactory.h"

@implementation OperationFactoriesAssembly

- (TokensOperationFactory *) tokensOperationFactory {
  return [TyphoonDefinition withClass:[TokensOperationFactory class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithBuilder:queryTransformer:bodyTransformer:headersBuilder:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self networkOperationBuilder]];
                                            [initializer injectParameterWith:[self tokensQueryTransformer]];
                                            [initializer injectParameterWith:[self contractsBodyTransformer]];
                                            [initializer injectParameterWith:[self headersBuilder]];
                                          }];
                        }];
}

- (AccountsOperationFactory *) accountsOperationFactory {
  return [TyphoonDefinition withClass:[AccountsOperationFactory class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithBuilder:queryTransformer:bodyTransformer:headersBuilder:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self networkOperationBuilder]];
                                            [initializer injectParameterWith:[self accountsQueryTransformer]];
                                            [initializer injectParameterWith:[self balanceBodyTransformer]];
                                            [initializer injectParameterWith:[self headersBuilder]];
                                          }];
                        }];
}

#pragma mark - Builders

- (NetworkCompoundOperationBuilder *) networkOperationBuilder
{
  return [TyphoonDefinition withClass:[NetworkCompoundOperationBuilder class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition useInitializer:@selector(initWithOperationChainer:)
                                          parameters:^(TyphoonMethod *initializer) {
                                            [initializer injectParameterWith:[self operationChainer]];
                                          }];
                          [definition injectProperty:@selector(requestConfiguratorsFactory)
                                                with:self.requestConfiguratorsFactory];
//                          [definition injectProperty:@selector(requestSignersFactory)
//                                                with:self.requestSignersFactory];
                          [definition injectProperty:@selector(networkClientsFactory)
                                                with:self.networkClientsFactory];
                          [definition injectProperty:@selector(responseDeserializersFactory)
                                                with:self.responseDeserializersFactory];
                          [definition injectProperty:@selector(responseValidatorsFactory)
                                                with:self.responseValidatorsFactory];
                          [definition injectProperty:@selector(responseMappersFactory)
                                                with:self.responseMappersFactory];
                          [definition injectProperty:@selector(responseConverterFactory)
                                                with:self.responseConverterFactory];
                        }];
}

#pragma mark - Query Transformers

- (QueryTransformerBase *) tokensQueryTransformer {
  return [TyphoonDefinition withClass:[QueryTransformerBase class]];
}

- (QueryTransformerBase *) accountsQueryTransformer {
  return [TyphoonDefinition withClass:[QueryTransformerBase class]];
}

#pragma mark - Body Transformers

- (ContractsBodyTransformer *) contractsBodyTransformer {
  return [TyphoonDefinition withClass:[ContractsBodyTransformer class]];
}

- (BalanceBodyTransformer *) balanceBodyTransformer {
  return [TyphoonDefinition withClass:[BalanceBodyTransformer class]];
}

#pragma mark - Headers Builders

- (HeadersBuilderBase *) headersBuilder {
  return [TyphoonDefinition withClass:[HeadersBuilderBase class]];
}

#pragma mark - Others

- (OperationChainer *) operationChainer
{
  return [TyphoonDefinition withClass:[OperationChainer class]];
}

@end
