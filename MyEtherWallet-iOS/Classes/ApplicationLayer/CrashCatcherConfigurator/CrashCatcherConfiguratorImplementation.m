//
//  CrashCatcherConfiguratorImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CrashCatcherConfiguratorImplementation.h"
#import "RateService.h"

__weak static CrashCatcherConfiguratorImplementation *_crashCatcher;

@interface CrashCatcherConfiguratorImplementation ()
- (void) _crashReceived;
@end

/* Exceptions handlers */

void HandleException(__unused NSException *exception) {
  [_crashCatcher _crashReceived];
  NSLog(@"App crashing with exception: %@", exception);
  //Save somewhere that your app has crashed.
}

void HandleSignal(__unused int signal) {
  [_crashCatcher _crashReceived];
  NSLog(@"We received a signal: %d", signal);
  //Save somewhere that your app has crashed.
}

@implementation CrashCatcherConfiguratorImplementation

- (void)configurate {
  _crashCatcher = self;
  
  NSSetUncaughtExceptionHandler(&HandleException);
  
  struct sigaction signalAction;
  memset(&signalAction, 0, sizeof(signalAction));
  signalAction.sa_handler = &HandleSignal;
  
  sigaction(SIGABRT, &signalAction, NULL);
  sigaction(SIGILL, &signalAction, NULL);
  sigaction(SIGBUS, &signalAction, NULL);
}

#pragma mark - Private

- (void) _crashReceived {
  [self.rateService clearCount];
}

@end
