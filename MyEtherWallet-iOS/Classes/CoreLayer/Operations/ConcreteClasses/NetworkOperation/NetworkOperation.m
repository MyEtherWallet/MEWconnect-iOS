//
//  NetworkOperation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "NetworkOperation.h"

#import "NetworkClient.h"
#import "ServerResponseModel.h"

@interface NetworkOperation ()
@property (nonatomic, strong) id<NetworkClient> networkClient;
@end

@implementation NetworkOperation

@synthesize delegate = _delegate;
@synthesize input = _input;
@synthesize output = _output;

#pragma mark - Initialization

- (instancetype)initWithNetworkClient:(id<NetworkClient>)networkClient {
  self = [super init];
  if (self) {
    _networkClient = networkClient;
  }
  return self;
}

+ (instancetype)operationWithNetworkClient:(id<NetworkClient>)networkClient {
  return [[[self class] alloc] initWithNetworkClient:networkClient];
}

#pragma mark - Operation execution

- (void)main {
  DDLogVerbose(@"The operation %@ is started", NSStringFromClass([self class]));
  NSURLRequest *inputData = [self.input obtainInputDataWithTypeValidationBlock:^BOOL(id data) {
    if ([data isKindOfClass:[NSURLRequest class]]) {
      DDLogVerbose(@"The input data for the operation %@ has passed the validation", NSStringFromClass([self class]));
      return YES;
    }
    DDLogVerbose(@"The input data for the operation %@ hasn't passed the validation. The input data type is: %@",
                 NSStringFromClass([self class]),
                 NSStringFromClass([data class]));
    return NO;
  }];
  
  DDLogVerbose(@"Start sending request to the remote server");
  @weakify(self);
  [self.networkClient sendRequest:inputData completionBlock:^(ServerResponseModel *responseModel, NSError *error) {
    @strongify(self);
    if (error) {
      DDLogError(@"NetworkClient in operation %@ has produced an error: %@", NSStringFromClass([self class]), error);
    }
    if (responseModel) {
      DDLogVerbose(@"Server returned data with length: %li", (unsigned long)[(NSData *)responseModel.data length]);
    }
    
    [self completeOperationWithData:responseModel error:error];
  }];
}

- (void)completeOperationWithData:(id)data error:(NSError *)error {
  if (error) {
    [self.delegate didCompleteChainableOperationWithError:error];
  } else if (data) {
    [self.output didCompleteChainableOperationWithOutputData:data];
    DDLogVerbose(@"The operation %@ output data has been passed to the buffer", NSStringFromClass([self class]));
  }
  
  DDLogVerbose(@"The operation %@ is over", NSStringFromClass([self class]));
  [self complete];
}

#pragma mark - Debug

- (NSString *)debugDescription {
  NSArray *additionalDebugInfo = @[[NSString stringWithFormat:@"Works with client: %@\n",
                                    [self.networkClient debugDescription]]];
  return [OperationDebugDescriptionFormatter debugDescriptionForOperation:self
                                                       withAdditionalInfo:additionalDebugInfo];
}

@end
