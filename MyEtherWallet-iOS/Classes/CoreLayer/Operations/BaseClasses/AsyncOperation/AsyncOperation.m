//
//  AsyncOperation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AsyncOperation.h"

static NSString *const kExecutingFlagSelector = @"isExecuting";
static NSString *const kFinishedFlagSelector = @"isFinished";

@implementation AsyncOperation {
  BOOL        executing;
  BOOL        finished;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    executing = NO;
    finished = NO;
  }
  return self;
}

#pragma mark - Getters

- (BOOL)isAsynchronous {
  return YES;
}

- (BOOL)isExecuting {
  return executing;
}

- (BOOL)isFinished {
  return finished;
}

#pragma mark - Private methods

- (void)start {
  if ([self isCancelled])
  {
    [self willChangeValueForKey:kFinishedFlagSelector];
    finished = YES;
    [self didChangeValueForKey:kFinishedFlagSelector];
    return;
  }
  [self willChangeValueForKey:kExecutingFlagSelector];
  
  [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
  executing = YES;
  [self didChangeValueForKey:kExecutingFlagSelector];
}

- (void)main {
  [NSException raise:NSInternalInconsistencyException format:@"You should override the method %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)complete {
  [self willChangeValueForKey:kFinishedFlagSelector];
  [self willChangeValueForKey:kExecutingFlagSelector];
  
  executing = NO;
  finished = YES;
  
  [self didChangeValueForKey:kExecutingFlagSelector];
  [self didChangeValueForKey:kFinishedFlagSelector];
}

@end
