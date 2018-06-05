//
//  CompoundOperationBase.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CompoundOperationBase.h"

#import "CompoundOperationDebugDescriptionFormatter.h"

static NSUInteger const DefaultMaxConcurrentOperationsCount = 3;
static NSString *const  OperationBaseQueueNameFormat = @"com.myetherwallet.mewconnect.%@-%@.queue";

@interface CompoundOperationBase ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation CompoundOperationBase

- (instancetype)init {
  
  self = [super init];
  if (self) {
    _queue = [[NSOperationQueue alloc] init];
    _queue.name = [NSString stringWithFormat:OperationBaseQueueNameFormat, NSStringFromClass([self class]), [[NSUUID UUID] UUIDString]];
    _queue.maxConcurrentOperationCount = _maxConcurrentOperationsCount > 0 ?: DefaultMaxConcurrentOperationsCount;
    
    [_queue setSuspended:YES];
  }
  return self;
}

- (void)main {
  [self.queue setSuspended:NO];
}

- (void)cancel {
  [super cancel];
  
  [self.queue setSuspended:YES];
  [self.queue cancelAllOperations];
  [self completeOperationWithData:nil error:nil];
}

- (void)addOperation:(NSOperation *)operation {
  [self.queue addOperation:operation];
}

#pragma mark - Protocol ChainableOperationDelegate

- (void)didCompleteChainableOperationWithError:(NSError *)error {
  id data = [self.queueOutput obtainOperationQueueOutputData];
  
  if (error || data) {
    [self completeOperationWithData:data error:error];
  }
}

#pragma mark - Private methods

- (void)completeOperationWithData:(id)data error:(NSError *)error {
  [self.queue setSuspended:YES];
  [self.queue cancelAllOperations];
  [self complete];
  
  if (self.resultBlock) {
    self.resultBlock(data, error);
  }
}

#pragma mark - Debug

- (NSString *)debugDescription {
  return [CompoundOperationDebugDescriptionFormatter debugDescriptionForCompoundOperation:self
                                                                        withInternalQueue:self.queue];
}

@end
