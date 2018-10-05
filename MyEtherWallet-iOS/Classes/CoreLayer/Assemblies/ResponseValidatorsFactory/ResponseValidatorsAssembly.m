//
//  ResponseValidatorsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ResponseValidatorsAssembly.h"

#import "SingleResponseValidator.h"
#import "ManyResponseValidator.h"
#import "FiatPricesResponseValidator.h"
#import "SimplexResponseValidator.h"
#import "EthereumResponseValidator.h"
#import "TokensResponseValidator.h"

@implementation ResponseValidatorsAssembly

#pragma mark - Option matcher

- (id<ResponseValidator>)validatorWithType:(NSNumber *)type {
  return [TyphoonDefinition withOption:type matcher:^(TyphoonOptionMatcher *matcher) {
    [matcher caseEqual:@(ResponseValidationDisabledType)
                   use:nil];
    [matcher caseEqual:@(ResponseValidationSingleType)
                   use:[self singleResponseValidator]];
    [matcher caseEqual:@(ResponseValidationManyType)
                   use:[self manyResponseValidator]];
    [matcher caseEqual:@(ResponseValidationFiatPricesType)
                   use:[self fiatPricesResponseValidator]];
    [matcher caseEqual:@(ResponseValidationSimplexType)
                   use:[self simplexResponseValidator]];
    [matcher caseEqual:@(ResponseValidationEthereumType)
                   use:[self ethereumResponseValidator]];
    [matcher caseEqual:@(ResponseValidationTokensType)
                   use:[self tokensResponseValidator]];
  }];
}

#pragma mark - Concrete definitions

- (id <ResponseValidator>) singleResponseValidator {
  return [TyphoonDefinition withClass:[SingleResponseValidator class]];
}

- (id <ResponseValidator>) manyResponseValidator {
  return [TyphoonDefinition withClass:[ManyResponseValidator class]];
}

- (id <ResponseValidator>) fiatPricesResponseValidator {
  return [TyphoonDefinition withClass:[FiatPricesResponseValidator class]];
}

- (id <ResponseValidator>) simplexResponseValidator {
  return [TyphoonDefinition withClass:[SimplexResponseValidator class]];
}

- (id <ResponseValidator>) ethereumResponseValidator {
  return [TyphoonDefinition withClass:[EthereumResponseValidator class]];
}

- (id <ResponseValidator>) tokensResponseValidator {
  return [TyphoonDefinition withClass:[TokensResponseValidator class]];
}

@end
