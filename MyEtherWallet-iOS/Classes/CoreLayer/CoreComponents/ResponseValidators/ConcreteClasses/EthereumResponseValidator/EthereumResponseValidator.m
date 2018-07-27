//
//  EthereumResponseValidator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "EthereumResponseValidator.h"

static NSString *const kEthereumResponseValidatorMessage = @"message";

static NSInteger const kEthereumResponseErrorCode        = 1;

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
    }
  }
  
  return resultError;
}

@end
