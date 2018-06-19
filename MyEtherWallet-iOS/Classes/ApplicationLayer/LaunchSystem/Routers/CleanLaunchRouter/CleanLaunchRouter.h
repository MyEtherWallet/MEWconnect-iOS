//
//  CleanLaunchRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol NavigationControllerFactory;
@protocol MEWWallet;

@interface CleanLaunchRouter : NSObject
@property (nonatomic, strong) id <MEWWallet> walletService;
@property (nonatomic, strong) UIStoryboard *passwordStoryboard;
- (instancetype)initWithNavigationControllerFactory:(id<NavigationControllerFactory>)navigationControllerFactory
                                             window:(UIWindow *)window;
- (void)openInitialScreen;
@end
