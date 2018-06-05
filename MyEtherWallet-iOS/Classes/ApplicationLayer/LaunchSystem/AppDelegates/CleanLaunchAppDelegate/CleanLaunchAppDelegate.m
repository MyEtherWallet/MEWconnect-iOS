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

#import "NSString+HexNSDecimalNumber.h"

@implementation CleanLaunchAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self.thirdPartiesConfigurator configurate];
  [self.applicationConfigurator setupCoreDataStack];
  [self.applicationConfigurator configureInitialSettings];
  [self.applicationConfigurator configurateAppearance];
  [self.cleanStartRouter openInitialScreen];
  return YES;
}

@end
