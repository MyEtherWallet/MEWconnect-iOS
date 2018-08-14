//
//  SimplexResponseValidator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SimplexResponseValidator.h"

static NSString *const kSimplexResponseValidatorResult    = @"result";
static NSString *const kSimplexResponseValidatorError     = @"error";

static NSInteger const kSimplexResponseErrorCode          = 1;

@implementation SimplexResponseValidator

- (NSError *)validateServerResponse:(id)response {
  NSError *resultError = nil;
  
  if ([response isKindOfClass:[NSDictionary class]]) {
    NSNumber *error = response[kSimplexResponseValidatorError];
    if ([error respondsToSelector:@selector(boolValue)] && [error boolValue]) {
      NSArray <NSString *> *reasons = response[kSimplexResponseValidatorResult];
      if ([reasons isKindOfClass:[NSString class]]) {
        reasons = @[(NSString *)reasons];
      } else if ([reasons isKindOfClass:[NSDictionary class]]) {
        reasons = @[@"Unknown reason"];
      }
      NSDictionary *userInfo = @{NSLocalizedDescriptionKey: reasons ? [reasons componentsJoinedByString:@", "] : @""};
      resultError = [NSError errorWithDomain:kResponseValidationErrorDomain
                                        code:kSimplexResponseErrorCode
                                    userInfo:userInfo];
    }
  }
  
  return resultError;
}

@end
