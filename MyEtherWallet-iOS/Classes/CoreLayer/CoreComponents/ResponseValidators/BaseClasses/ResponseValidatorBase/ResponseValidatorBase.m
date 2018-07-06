//
//  ResponseValidatorBase.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ResponseValidatorBase.h"

static NSUInteger const kInvalidResponseErrorCode = 1;

NSString *const kResponseValidationErrorDomain = @"com.myetherwallet.mewconnect.validation-error-domain";

@implementation ResponseValidatorBase

- (BOOL)validateResponseIsDictionaryClass:(id)response
                                    error:(NSError *__autoreleasing *)error {
  if (![response isKindOfClass: [NSDictionary class]]) {
    NSDictionary *userData = @{@"response" : (response ?: [NSNull null])};
    if (!*error) {
      *error = [NSError errorWithDomain:kResponseValidationErrorDomain
                                   code:kInvalidResponseErrorCode
                               userInfo:userData];
    }
    return NO;
  }
  return YES;
}

- (BOOL)validateResponseIsArrayClass:(id)response
                               error:(NSError *__autoreleasing *)error {
  if (![response isKindOfClass: [NSArray class]]) {
    NSDictionary *userData = @{@"response" : (response ?: [NSNull null])};
    if (!*error) {
      *error = [NSError errorWithDomain:kResponseValidationErrorDomain
                                   code:kInvalidResponseErrorCode
                               userInfo:userData];
    }
    return NO;
  }
  return YES;
}

#pragma mark - Debug Description

- (NSString *)debugDescription {
  return NSStringFromClass([self class]);
}

@end
