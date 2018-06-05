//
//  CommonNetworkClient.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CommonNetworkClient.h"
#import "ServerResponseModel.h"

@interface CommonNetworkClient ()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation CommonNetworkClient

#pragma mark - Initialization

- (instancetype)initWithURLSession:(NSURLSession *)session {
  self = [super init];
  if (self) {
    _session = session;
  }
  return self;
}

#pragma mark - RCFNetworkClient

- (void)sendRequest:(NSURLRequest *)request completionBlock:(NetworkClientCompletionBlock)block {
  NSAssert(request != nil, @"NSURLRequest should not be nil");
  
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (block) {
      NSHTTPURLResponse *serverResponse = nil;
      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        serverResponse = (NSHTTPURLResponse *)response;
      }
      ServerResponseModel *model = [[ServerResponseModel alloc] initWithResponse:serverResponse
                                                                            data:data];
      block(model, error);
    }
  }];
  
  
  [dataTask resume];
}

#pragma mark - Debug Description

- (NSString *)debugDescription {
  return NSStringFromClass([self class]);
}

@end

