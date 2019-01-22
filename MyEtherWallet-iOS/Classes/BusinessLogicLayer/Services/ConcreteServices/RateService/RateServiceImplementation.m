//
//  RateServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import StoreKit;

#import "RateServiceImplementation.h"
#import "KeychainService.h"

static NSString *const kRateServiceImplementationRaterVersion           = @"group.myetherwallet.userdefaults.raterversion";
static NSString *const kRateServiceImplementationLaunchCount            = @"group.myetherwallet.userdefaults.launchcount";
static NSString *const kRateServiceImplementationBalanceUpdateCount     = @"group.myetherwallet.userdefaults.balanceupdate";

static NSInteger const kRateServiceImplementationNumberOfLaunchCount    = 5;
static NSInteger const kRateServiceImplementationNumberOfBalanceUpdate  = 10;
static NSInteger const kRateServiceImplementationCurrentRaterVersion    = 2;

@implementation RateServiceImplementation

- (void) checkForUpdate {
  NSInteger version = [self.userDefaults integerForKey:kRateServiceImplementationRaterVersion];
  if (version != kRateServiceImplementationCurrentRaterVersion) {
    [self clearCount];
    [self.keychainService resetRateStatus];
    [self.userDefaults setInteger:kRateServiceImplementationCurrentRaterVersion forKey:kRateServiceImplementationRaterVersion];
    [self.userDefaults synchronize];
  }
}

- (void) balanceUpdated {
  NSInteger count = [self.userDefaults integerForKey:kRateServiceImplementationBalanceUpdateCount];
  ++count;
  [self.userDefaults setInteger:count forKey:kRateServiceImplementationBalanceUpdateCount];
  [self.userDefaults synchronize];
}

- (void) applicationLaunched {
  NSInteger count = [self.userDefaults integerForKey:kRateServiceImplementationLaunchCount];
  ++count;
  [self.userDefaults setInteger:count forKey:kRateServiceImplementationLaunchCount];
  [self.userDefaults synchronize];
}

- (void) clearCount {
  [self.userDefaults removeObjectForKey:kRateServiceImplementationLaunchCount];
  [self.userDefaults removeObjectForKey:kRateServiceImplementationBalanceUpdateCount];
  [self.userDefaults synchronize];
}

- (void) requestReviewIfNeeded {
  NSInteger launchCount = [self.userDefaults integerForKey:kRateServiceImplementationLaunchCount];
  NSInteger updateCount = [self.userDefaults integerForKey:kRateServiceImplementationBalanceUpdateCount];
  
  if (launchCount >= kRateServiceImplementationNumberOfLaunchCount
      && updateCount >= kRateServiceImplementationNumberOfBalanceUpdate
      && ![self.keychainService obtainRateStatus]) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
        [self.keychainService rateDidAsked];
      }
    });
  }
}

@end
