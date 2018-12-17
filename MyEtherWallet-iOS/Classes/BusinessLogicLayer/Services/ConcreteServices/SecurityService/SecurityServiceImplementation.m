//
//  SecurityServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 07/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SecurityServiceImplementation.h"

static CFTimeInterval const kSecurityServiceImplementationDefaultTimeout  = 300.0;

@interface SecurityServiceImplementation ()
@property (nonatomic) BOOL forceProtection;
@property (nonatomic) BOOL oneTimeProtection;
@property (nonatomic) BOOL timeProtection;
@property (nonatomic) CFAbsoluteTime resignTime;
@end

@implementation SecurityServiceImplementation

#pragma mark - LifeCycle

- (instancetype) init {
  self = [super init];
  if (self) {
    self.resignTime = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_systemTimeDidChange:) name:NSSystemClockDidChangeNotification object:nil];
  }
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)registerResignActive {
  self.resignTime = CFAbsoluteTimeGetCurrent();
}

- (void)registerBecomeActive {
  if (self.resignTime > 0) {
    self.timeProtection = (CFAbsoluteTimeGetCurrent() - self.resignTime) > kSecurityServiceImplementationDefaultTimeout;
  }
}

- (void) enableForceProtection {
  self.forceProtection = YES;
}

- (void) disableForceProtection {
  self.forceProtection = NO;
}

- (BOOL) obtainProtectionStatus {
  return self.forceProtection || self.oneTimeProtection || self.timeProtection;
}

- (void) resetOneTimeProtection {
  self.oneTimeProtection = NO;
}
     
#pragma mark - Notifications

- (void) _systemTimeDidChange:(__unused NSNotification *)notification {
  self.oneTimeProtection = YES;
}

@end
