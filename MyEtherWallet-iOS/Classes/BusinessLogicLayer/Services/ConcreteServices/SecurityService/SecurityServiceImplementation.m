//
//  SecurityServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 07/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "KeychainService.h"
#import "SecurityServiceImplementation.h"

static CFTimeInterval const kSecurityServiceImplementationDefaultTimeout              = 300.0;
static NSInteger const      kSecurityServiceImplementationNumberOfIncorrectAttempts   = 5;
#if DEBUG
static NSTimeInterval const kSecurityServiceImplementationUnlockTimeout               = 120.0;
#else
static NSTimeInterval const kSecurityServiceImplementationUnlockTimeout               = 300.0;
#endif

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

- (void) incorrectAttempt {
  NSInteger numberOfAttempts = [self.keychainService obtainNumberOfPasswordAttempts];
  ++numberOfAttempts;
  if (numberOfAttempts >= kSecurityServiceImplementationNumberOfIncorrectAttempts) {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:kSecurityServiceImplementationUnlockTimeout];
    [self.keychainService savePasswordUnlockDate:date];
    [self.keychainService savePasswordAttempts:0];
  } else {
    [self.keychainService savePasswordAttempts:numberOfAttempts];
  }
}

- (void) correctAttempt {
  [self.keychainService savePasswordAttempts:0];
}

- (BOOL) isInputLocked {
  NSDate *unlockDate = [self.keychainService obtainPasswordUnlockDate];
  NSDate *now = [NSDate date];
  BOOL locked = unlockDate && [now compare:unlockDate] != NSOrderedDescending;
  return locked;
}

- (NSDate * __nullable) unlockTime {
  return [self.keychainService obtainPasswordUnlockDate];
}
     
#pragma mark - Notifications

- (void) _systemTimeDidChange:(__unused NSNotification *)notification {
  self.oneTimeProtection = YES;
}

@end
