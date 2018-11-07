//
//  SecurityAppDelegate.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SecurityAppDelegate.h"

#import "SecurityService.h"
#import "SecurityRouter.h"

@implementation SecurityAppDelegate

- (void)applicationWillResignActive:(UIApplication *)application {
  [self.securityService registerResignActive];
  [self.securityRouter openSecureView];
  [application ignoreSnapshotOnNextApplicationLaunch];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [self.securityRouter openSecureView];
  [application ignoreSnapshotOnNextApplicationLaunch];
}

- (void)applicationDidBecomeActive:(__unused UIApplication *)application {
  [self.securityService registerBecomeActive];
  [self.securityRouter closeSecureView];
}

@end
