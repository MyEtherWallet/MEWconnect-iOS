//
//  ReachabilityServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 31/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import AFNetworking.AFNetworkReachabilityManager;
@import libextobjc.EXTScope;

#import "ReachabilityServiceImplementation.h"

#import "ReachabilityServiceDelegate.h"

@implementation ReachabilityServiceImplementation

- (instancetype) initWithNetworkReachabilityManager:(AFNetworkReachabilityManager *)manager {
  self = [super init];
  if (self) {
    _reachabilityManager = manager;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    @weakify(self);
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      @strongify(self);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate reachabilityStatusDidChanged:(status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN)];
      });
    }];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
      [self.reachabilityManager startMonitoring];
    }
  }
  return self;
}

- (void) dealloc {
  [self.reachabilityManager stopMonitoring];
}

#pragma mark - Notification

- (void) _applicationDidBecomeActive:(__unused NSNotification *)notification {
  [self.reachabilityManager startMonitoring];
}

- (void) _applicationWillResignActive:(__unused NSNotification *)notification {
  [self.reachabilityManager stopMonitoring];
}
@end
