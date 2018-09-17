//
//  EthereumResponseValidator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "EthereumResponseValidator.h"

#import "NSString+HexNSDecimalNumber.h"

static NSString *const kEthereumResponseValidatorMessage          = @"message";
static NSString *const kEthereumResponseValidatorResult           = @"result";
static NSString *const kEthereumResponseValidatorId               = @"id";

static NSInteger const kEthereumResponseErrorCode                 = 1;
static NSInteger const kEthereumResponseIncorrectFormatErrorCode  = 2;

@implementation EthereumResponseValidator

- (NSError *)validateServerResponse:(id)response {
  NSError *resultError = nil;
  
  if ([response isKindOfClass:[NSDictionary class]]) {
    NSString *message = response[kEthereumResponseValidatorMessage];
    if (message) {
      NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
      resultError = [NSError errorWithDomain:kResponseValidationErrorDomain
                                        code:kEthereumResponseErrorCode
                                    userInfo:userInfo];
    } else {
      NSDecimalNumber *balance = [response[kEthereumResponseValidatorResult] decimalNumberFromHexRepresentation];
      NSString *addressString = response[kEthereumResponseValidatorId];
      if (!balance || !addressString) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Incorrect format", @"Ethereum balance validator")};
        resultError = [NSError errorWithDomain:kResponseValidationErrorDomain
                                          code:kEthereumResponseIncorrectFormatErrorCode
                                      userInfo:userInfo];
      }
    }
  } else {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Incorrect format", @"Ethereum balance validator")};
    resultError = [NSError errorWithDomain:kResponseValidationErrorDomain
                                      code:kEthereumResponseIncorrectFormatErrorCode
                                  userInfo:userInfo];
  }
  
  return resultError;
}

@end
