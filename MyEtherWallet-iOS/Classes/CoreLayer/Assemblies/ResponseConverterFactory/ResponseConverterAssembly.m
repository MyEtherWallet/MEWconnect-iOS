//
//  ResponseConverterAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ResponseConverterAssembly.h"

#import "ResponseConverterImplementation.h"
#import "TokensResponseConverterImplementation.h"
#import "EthereumResponseConverterImplementation.h"
#import "TickerResponseConverterImplementation.h"
#import "SimplexResponseConverterImplementation.h"

#import "ResponseConvertingType.h"

@implementation ResponseConverterAssembly

- (id<ResponseConverter>)converterWithType:(NSNumber *)type {
  return [TyphoonDefinition withOption:type matcher:^(TyphoonOptionMatcher *matcher) {
    [matcher caseEqual:@(ResponseConvertingDefaultType)
                   use:[self defaultConverter]];
    [matcher caseEqual:@(ResponseConvertingTokensType)
                   use:[self tokensConverter]];
    [matcher caseEqual:@(ResponseConvertingEthereumType)
                   use:[self ethereumConverter]];
    [matcher caseEqual:@(ResponseConvertingTickerType)
                   use:[self tickerConverter]];
    [matcher caseEqual:@(ResponseConvertingSimplexType)
                   use:[self simplexConverter]];
  }];
}

#pragma mark - Converters

- (ResponseConverterImplementation *) defaultConverter {
  return [TyphoonDefinition withClass:[ResponseConverterImplementation class]];
}

- (TokensResponseConverterImplementation *) tokensConverter {
  return [TyphoonDefinition withClass:[TokensResponseConverterImplementation class]];
}

- (EthereumResponseConverterImplementation *) ethereumConverter {
  return [TyphoonDefinition withClass:[EthereumResponseConverterImplementation class]];
}

- (TickerResponseConverterImplementation *) tickerConverter {
  return [TyphoonDefinition withClass:[TickerResponseConverterImplementation class]];
}

- (SimplexResponseConverterImplementation *) simplexConverter {
  return [TyphoonDefinition withClass:[SimplexResponseConverterImplementation class]];
}

@end
