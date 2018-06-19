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
  }];
}

#pragma mark - Concrete definitions

- (id<ResponseValidator>)singleResponseValidator {
  return [TyphoonDefinition withClass:[SingleResponseValidator class]];
}

- (id<ResponseValidator>)manyResponseValidator {
  return [TyphoonDefinition withClass:[ManyResponseValidator class]];
}

@end
