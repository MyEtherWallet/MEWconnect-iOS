//
//  ResponseConverterOperation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "ResponseConverterOperation.h"

#import "ResponseConverter.h"

@interface ResponseConverterOperation ()
@property (nonatomic, strong) id<ResponseConverter> responseConverter;
@end

@implementation ResponseConverterOperation

@synthesize delegate = _delegate;
@synthesize input = _input;
@synthesize output = _output;

- (instancetype)initWithResponseConverter:(id<ResponseConverter>)responseConverter {
  self = [super init];
  if (self) {
    _responseConverter = responseConverter;
  }
  return self;
}

+ (instancetype)operationWithResponseConverter:(id<ResponseConverter>)responseConverter {
  return [[[self class] alloc] initWithResponseConverter:responseConverter];
}

#pragma mark - Operation execution

- (void)main {
  DDLogVerbose(@"The operation %@ is started", NSStringFromClass([self class]));
  NSDictionary *inputData = [self.input obtainInputDataWithTypeValidationBlock:^BOOL(id data) {
    if ([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSArray class]] || data == nil) {
      DDLogVerbose(@"The input data for the operation %@ has passed the validation", NSStringFromClass([self class]));
      return YES;
    }
    DDLogVerbose(@"The input data for the operation %@ hasn't passed the validation. The input data type is: %@",
                 NSStringFromClass([self class]),
                 NSStringFromClass([data class]));
    return NO;
  }];
  
  NSError *error = nil;
  NSDictionary *response =  [self.responseConverter convertFromResponse:inputData error:&error];
  
  DDLogVerbose(@"Successfully convert a response: %@", response);
  [self completeOperationWithData:response error:error];
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
                                    [self.responseConverter debugDescription]]];
  return [OperationDebugDescriptionFormatter debugDescriptionForOperation:self
                                                       withAdditionalInfo:additionalDebugInfo];
}

@end
