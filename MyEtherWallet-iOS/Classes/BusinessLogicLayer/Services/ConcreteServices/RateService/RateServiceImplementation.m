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

static NSString *const kRateServiceImplementationCountKey = @"group.myetherwallet.userdefaults.signedcount";
static NSInteger const kRateServiceImplementationNumberOfTransactionsForReview = 2;

@implementation RateServiceImplementation

- (void) transactionSigned {
  NSInteger count = [self.userDefaults integerForKey:kRateServiceImplementationCountKey];
  ++count;
  [self.userDefaults setInteger:count forKey:kRateServiceImplementationCountKey];
  [self.userDefaults synchronize];
}

- (void) clearCount {
  [self.userDefaults removeObjectForKey:kRateServiceImplementationCountKey];
  [self.userDefaults synchronize];
}

- (void) requestReviewIfNeeded {
  NSInteger count = [self.userDefaults integerForKey:kRateServiceImplementationCountKey];
  if (count >= kRateServiceImplementationNumberOfTransactionsForReview && ![self.keychainService obtainRateStatus]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
        [self.keychainService rateDidAsked];
      }
    });
  }
}

@end
