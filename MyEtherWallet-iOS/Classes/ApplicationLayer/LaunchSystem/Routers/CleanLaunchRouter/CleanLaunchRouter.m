//
//  CleanLaunchRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;
@import ViperMcFlurry;

#import "CleanLaunchRouter.h"
#import "NavigationControllerFactory.h"

#import "MEWwallet.h"

#import "SplashPasswordModuleInput.h"

static NSString *const kSplashPasswordViewControllerIdentifier  = @"SplashPasswordViewController";

@interface CleanLaunchRouter ()
@property (nonatomic, strong) id <NavigationControllerFactory> navigationControllerFactory;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation CleanLaunchRouter

#pragma mark - Initialization

- (instancetype)initWithNavigationControllerFactory:(id<NavigationControllerFactory>)navigationControllerFactory
                                             window:(UIWindow *)window {
  self = [super init];
  if (self) {
    _navigationControllerFactory = navigationControllerFactory;
    _window = window;
  }
  return self;
}

#pragma mark - Public

- (void)openInitialScreen {
  NSString *address = [self.walletService obtainPublicAddress];
  UINavigationController *navigationController = [self.navigationControllerFactory obtainPreconfiguredAuthorizedNavigationControllerWithAddress:address];
  self.window.rootViewController = navigationController;
  [self.window makeKeyAndVisible];
  
  if (self.passwordStoryboard && address) {
    /* To prevent "Unbalanced calls to begin/end appearance transitions for..." */
    dispatch_async(dispatch_get_main_queue(), ^{
      RamblerViperModuleFactory *passwordFactory = [[RamblerViperModuleFactory alloc] initWithStoryboard:self.passwordStoryboard
                                                                                        andRestorationId:kSplashPasswordViewControllerIdentifier];
      [[navigationController.topViewController openModuleUsingFactory:passwordFactory
                                                  withTransitionBlock:[self passwordTransitionBlock]]
       thenChainUsingBlock:[self passwordConfigurationBlock]];
      
    });
  }
}

#pragma mark - Private

- (ModuleTransitionBlock) passwordTransitionBlock {
  return ^(id<RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler, id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
    UIViewController *destinationViewController = (id)destinationModuleTransitionHandler;
    UIViewController *sourceViewController = (id)sourceModuleTransitionHandler;
    [sourceViewController presentViewController:destinationViewController
                                       animated:NO
                                     completion:nil];
  };
}

- (RamblerViperModuleLinkBlock) passwordConfigurationBlock {
  return ^id<RamblerViperModuleOutput>(id<SplashPasswordModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  };
}

@end
