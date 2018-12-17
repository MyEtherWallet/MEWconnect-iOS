//
//  FiatPricesResponseValidator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "FiatPricesResponseValidator.h"

static NSString *const kFiatPricesResponseValidatorResult   = @"result";
static NSString *const kFiatPricesResponseValidatorError    = @"error";
static NSString *const kFiatPricesResponseValidatorMessage  = @"message";

@implementation FiatPricesResponseValidator

- (NSError *)validateServerResponse:(id)response {
  NSError *resultError = nil;
  
  if ([response isKindOfClass:[NSDictionary class]]) {
    NSDictionary *data = response[kFiatPricesResponseValidatorResult];
    if ([data isKindOfClass:[NSDictionary class]]) {
      NSNumber *errorCode = data[kFiatPricesResponseValidatorError];
      NSString *message = data[kFiatPricesResponseValidatorMessage];
      if (errorCode != nil) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message ?: @""};
        resultError = [NSError errorWithDomain:kResponseValidationErrorDomain
                                          code:[errorCode unsignedIntegerValue]
                                      userInfo:userInfo];
      }
    }
  }
  
  return resultError;
}

@end
