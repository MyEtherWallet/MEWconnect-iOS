//
//  SplashPasswordInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordInteractor.h"

#import "AccountsService.h"
#import "SecurityService.h"
#import "MEWwallet.h"
#import "Ponsomizer.h"

#import "NetworkPlainObject.h"
#import "AccountPlainObject.h"

#import "SplashPasswordInteractorOutput.h"

@interface SplashPasswordInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SplashPasswordInteractor

- (void) dealloc {
  [self.timer invalidate];
}

#pragma mark - SplashPasswordInteractorInput

- (void) configurateWithAccount:(AccountPlainObject *)account {
  self.account = account;
  [self _startUnlockTimerIfNeeded];
}

- (AccountPlainObject *) obtainAccount {
  return self.account;
}

- (void)checkPassword:(NSString *)password {
  BOOL validated = [self.walletService validatePassword:password account:self.account];
  if (validated) {
    [self.securityService correctAttempt];
    [self.output correctPassword:password];
  } else {
    [self.securityService incorrectAttempt];
    [self.output incorrectPassword];
    [self _startUnlockTimerIfNeeded];
  }
}

- (BOOL) isPasswordLocked {
  return [self.securityService isInputLocked];
}

#pragma mark - Private

- (void) _startUnlockTimerIfNeeded {
  if ([self.timer isValid]) {
    return;
  }
  if ([self.securityService isInputLocked]) {
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(_unlockTick:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
  }
}

- (void) _unlockTick:(NSTimer *)timer {
  if (![self.securityService isInputLocked]) {
    [timer invalidate];
    [self.output passwordDidUnlocked];
  } else {
    NSDate *unlockDate = [self.securityService unlockTime];
    NSTimeInterval unlockIn = ceil([unlockDate timeIntervalSinceDate:[NSDate date]]);
    [self.output passwordWillBeUnlockedIn:unlockIn];
  }
}

@end
