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
  }];
  
}

- (ResponseConverterImplementation *) defaultConverter {
  return [TyphoonDefinition withClass:[ResponseConverterImplementation class]];
}

- (TokensResponseConverterImplementation *) tokensConverter {
  return [TyphoonDefinition withClass:[TokensResponseConverterImplementation class]];
}

- (EthereumResponseConverterImplementation *) ethereumConverter {
  return [TyphoonDefinition withClass:[EthereumResponseConverterImplementation class]];
}

@end
