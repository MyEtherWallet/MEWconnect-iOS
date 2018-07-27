//
//  CleanLaunchRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol NavigationControllerFactory;
@protocol AccountsService;
@protocol Ponsomizer;
@protocol PropertyAnimatorsFactory;

@interface CleanLaunchRouter : NSObject
@property (nonatomic, strong) id <PropertyAnimatorsFactory> propertyAnimatorsFactory;
@property (nonatomic, strong) id <AccountsService> accountsService;
@property (nonatomic, strong) id <Ponsomizer> ponsomizer;
@property (nonatomic, strong) UIStoryboard *passwordStoryboard;
@property (nonatomic, strong) UIStoryboard *launchStoryboard;
- (instancetype) initWithNavigationControllerFactory:(id<NavigationControllerFactory>)navigationControllerFactory
                                              window:(UIWindow *)window;
- (void) openInitialScreen;
@end
