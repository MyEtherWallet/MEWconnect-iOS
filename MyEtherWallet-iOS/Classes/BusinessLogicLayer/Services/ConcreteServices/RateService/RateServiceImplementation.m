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

static NSString *const kRateServiceImplementationRaterVersion               = @"group.myetherwallet.userdefaults.raterversion";
static NSString *const kRateServiceImplementationBalanceUpdateCount         = @"group.myetherwallet.userdefaults.balanceupdate";
static NSString *const kRateServiceImplementationPhase                      = @"group.myetherwallet.userdefaults.phase";

static NSInteger const kRateServiceImplementationNumberOfBalanceUpdate      = 10;
static NSInteger const kRateServiceImplementationNextNumberOfBalanceUpdate  = 100;
static NSInteger const kRateServiceImplementationCurrentRaterVersion        = 3;

@implementation RateServiceImplementation

- (void) checkForUpdate {
  NSInteger version = [self.userDefaults integerForKey:kRateServiceImplementationRaterVersion];
  if (version != kRateServiceImplementationCurrentRaterVersion) {
    [self clearCount];
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

- (void) clearCount {
  [self.userDefaults removeObjectForKey:kRateServiceImplementationPhase];
  [self.userDefaults removeObjectForKey:kRateServiceImplementationBalanceUpdateCount];
  [self.userDefaults synchronize];
}

- (void) requestReviewIfNeeded {
  NSInteger updateCount = [self.userDefaults integerForKey:kRateServiceImplementationBalanceUpdateCount];
  NSInteger requiredCount = kRateServiceImplementationNumberOfBalanceUpdate + [self.userDefaults integerForKey:kRateServiceImplementationPhase] * kRateServiceImplementationNextNumberOfBalanceUpdate;
  
  if (updateCount >= requiredCount) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
        NSInteger phase = [self.userDefaults integerForKey:kRateServiceImplementationPhase];
        ++phase;
        [self.userDefaults setInteger:phase forKey:kRateServiceImplementationPhase];
        [self.userDefaults synchronize];
      }
    });
  }
}

@end
