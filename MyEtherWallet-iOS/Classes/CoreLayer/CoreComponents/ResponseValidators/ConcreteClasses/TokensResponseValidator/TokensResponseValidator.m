//
//  TokensResponseValidator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TokensResponseValidator.h"

static NSString *const kTokensResponseValidatorMessage          = @"message";
static NSString *const kTokensResponseValidatorResult           = @"result";

static NSInteger const kTokensResponseErrorCode                 = 1;
static NSInteger const kTokensResponseIncorrectFormatErrorCode  = 2;


@implementation TokensResponseValidator

- (NSError *)validateServerResponse:(id)response {
  NSError *resultError = nil;
  
  if ([response isKindOfClass:[NSDictionary class]]) {
    NSString *message = response[kTokensResponseValidatorMessage];
    if (message) {
      NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
      resultError = [NSError errorWithDomain:kResponseValidationErrorDomain
                                        code:kTokensResponseErrorCode
                                    userInfo:userInfo];
    } else {
      NSString *tokens = response[kTokensResponseValidatorResult];
      if (![tokens isKindOfClass:[NSString class]]) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Incorrect format", @"Tokens validator")};
        resultError = [NSError errorWithDomain:kResponseValidationErrorDomain
                                          code:kTokensResponseIncorrectFormatErrorCode
                                      userInfo:userInfo];
      }
    }
  } else {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Incorrect format", @"Tokens validator")};
    resultError = [NSError errorWithDomain:kResponseValidationErrorDomain
                                      code:kTokensResponseIncorrectFormatErrorCode
                                  userInfo:userInfo];
  }
  
  return resultError;
}

@end
