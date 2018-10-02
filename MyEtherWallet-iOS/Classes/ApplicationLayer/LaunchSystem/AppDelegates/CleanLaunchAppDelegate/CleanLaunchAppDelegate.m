//
//  CleanLaunchAppDelegate.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CleanLaunchAppDelegate.h"

#import "CleanLaunchRouter.h"
#import "ApplicationConfigurator.h"
#import "ThirdPartiesConfigurator.h"
#import "CoreDataConfigurator.h"
#import "CrashCatcherConfigurator.h"

@implementation CleanLaunchAppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self.crashCatcherConfigurator configurate];
  [self.thirdPartiesConfigurator configurate];
  [self.coreDataConfigurator setupCoreDataStack];
  [self.applicationConfigurator configureInitialSettings];
  [self.applicationConfigurator configurateAppearance];
  [self.cleanStartRouter openInitialScreen];
  return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [self.thirdPartiesConfigurator cleanup];
}

@end
