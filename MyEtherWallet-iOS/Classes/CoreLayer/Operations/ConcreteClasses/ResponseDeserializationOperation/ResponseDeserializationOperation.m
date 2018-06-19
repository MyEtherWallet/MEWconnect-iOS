//
//  ResponseDeserializationOperation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "ResponseDeserializationOperation.h"

#import "ResponseDeserializer.h"

#import "ServerResponseModel.h"

@interface ResponseDeserializationOperation ()
@property (nonatomic, strong) id<ResponseDeserializer> responseDeserializer;
@end

@implementation ResponseDeserializationOperation

@synthesize delegate = _delegate;
@synthesize input = _input;
@synthesize output = _output;

#pragma mark - Initialization

- (instancetype)initWithResponseDeserializer:(id<ResponseDeserializer>)responseDeserializer {
  self = [super init];
  if (self) {
    _responseDeserializer = responseDeserializer;
  }
  return self;
}

+ (instancetype)operationWithResponseDeserializer:(id<ResponseDeserializer>)responseDeserializer {
  return [[[self class] alloc] initWithResponseDeserializer:responseDeserializer];
}

#pragma mark - Operation execution

- (void)main {
  DDLogVerbose(@"The operation %@ is started", NSStringFromClass([self class]));
  ServerResponseModel *inputData = [self.input obtainInputDataWithTypeValidationBlock:^BOOL(id data) {
    if ([data isKindOfClass:[ServerResponseModel class]]) {
      DDLogVerbose(@"The input data for the operation %@ has passed the validation", NSStringFromClass([self class]));
      return YES;
    }
    DDLogVerbose(@"The input data for the operation %@ hasn't passed the validation. The input data type is: %@",
                 NSStringFromClass([self class]),
                 NSStringFromClass([data class]));
    return NO;
  }];
  
  DDLogVerbose(@"Start server response deserialization");
  @weakify(self);
  [self.responseDeserializer deserializeServerResponse:inputData.data completionBlock:^(NSDictionary *response, NSError *error) {
    
    @strongify(self);
    if (error) {
      DDLogError(@"ResponseDeserializer in operation %@ has produced error: %@", NSStringFromClass([self class]), error);
    }
    if (response) {
      DDLogVerbose(@"The server response was successfully deserialized: %@", response);
    }
    
    [self completeOperationWithData:response error:error];
  }];
}

- (void)completeOperationWithData:(id)data error:(NSError *)error {
  if (data) {
    [self.output didCompleteChainableOperationWithOutputData:data];
    DDLogVerbose(@"The operation %@ output data has been passed to the buffer", NSStringFromClass([self class]));
  }
  
  [self.delegate didCompleteChainableOperationWithError:error];
  DDLogVerbose(@"The operation %@ is over", NSStringFromClass([self class]));
  [self complete];
}

#pragma mark - Debug

- (NSString *)debugDescription {
  NSArray *additionalDebugInfo = @[[NSString stringWithFormat:@"Works with deserializer: %@\n",
                                    [self.responseDeserializer debugDescription]]];
  return [OperationDebugDescriptionFormatter debugDescriptionForOperation:self
                                                       withAdditionalInfo:additionalDebugInfo];
}

@end
