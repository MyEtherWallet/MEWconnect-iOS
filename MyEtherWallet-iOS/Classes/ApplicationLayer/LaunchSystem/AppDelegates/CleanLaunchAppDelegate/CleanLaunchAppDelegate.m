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
#import "MigrationService.h"
#import "CoreDataConfigurator.h"
#import "CrashCatcherConfigurator.h"

@implementation CleanLaunchAppDelegate

- (BOOL) application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions {
  [self.crashCatcherConfigurator configurate];
  [self.thirdPartiesConfigurator configurate];
  if ([self.migrationService isMigrationNeeded]) {
    NSError *error = nil;
    [self.migrationService migrate:&error];
    if (error) {
      NSLog(@"%@", error);
    }
  } else if ([self.migrationService isMigrationNeededForKeychain]) {
    NSError *error = nil;
    [self.migrationService migratekeychain:&error];
    if (error) {
      NSLog(@"%@", error);
    }
  }
  [self.coreDataConfigurator setupCoreDataStack];
  [self.applicationConfigurator configureInitialSettings];
  [self.applicationConfigurator configurateAppearance];
  [self.cleanStartRouter openInitialScreen];
  return YES;
}

- (void)applicationWillTerminate:(__unused UIApplication *)application {
  [self.thirdPartiesConfigurator cleanup];
}

@end
