//
//  CleanLaunchAppDelegate.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@protocol ApplicationConfigurator;
@protocol ThirdPartiesConfigurator;
@protocol CoreDataConfigurator;
@class CleanLaunchRouter;

@interface CleanLaunchAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) id <ApplicationConfigurator> applicationConfigurator;
@property (nonatomic, strong) id <ThirdPartiesConfigurator> thirdPartiesConfigurator;
@property (nonatomic, strong) id <CoreDataConfigurator> coreDataConfigurator;
@property (nonatomic, strong) CleanLaunchRouter *cleanStartRouter;
@end
