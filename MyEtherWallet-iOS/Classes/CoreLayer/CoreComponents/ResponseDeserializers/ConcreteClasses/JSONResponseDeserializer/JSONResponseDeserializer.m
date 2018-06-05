//
//  JSONResponseDeserializer.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "JSONResponseDeserializer.h"

static NSString *const kPlainTextContentType = @"text/plain";

@implementation JSONResponseDeserializer

#pragma mark - Initialization

- (instancetype)init {
  self = [super init];
  if (self) {
    NSMutableSet *contentTypes = [self.acceptableContentTypes mutableCopy];
    [contentTypes addObject:kPlainTextContentType];
    self.acceptableContentTypes = [contentTypes copy];
  }
  return self;
}

#pragma mark - RCFResponseDeserializer

- (void)deserializeServerResponse:(NSData *)responseData completionBlock:(ResponseDeserializerCompletionBlock)block {
  NSAssert(block, @"Block shouldn't be nil");
  NSError *error;
  NSDictionary *deserializedResponse = [super responseObjectForResponse:nil
                                                                   data:responseData
                                                                  error:&error];
  block(deserializedResponse, error);
}

#pragma mark - Debug Description

- (NSString *)debugDescription {
  return NSStringFromClass([self class]);
}

@end
