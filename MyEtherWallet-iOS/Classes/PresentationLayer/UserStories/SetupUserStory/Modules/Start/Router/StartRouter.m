//
//  StartRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "StartRouter.h"

#import "HomeModuleInput.h"
#import "RestoreOptionsModuleInput.h"
#import "PasswordModuleInput.h"

static NSString *const kStartToPasswordSegueIdentifier        = @"StartToPasswordSegueIdentifier";
static NSString *const kStartToHomeSegueIdentifier            = @"StartToHomeSegueIdentifier";
static NSString *const kStartToRestoreOptionsSegueIdentifier  = @"StartToRestoreOptionsSegueIdentifier";

@implementation StartRouter

#pragma mark - StartRouterInput

- (void) openCreateNewWallet {
  [[self.transitionHandler openModuleUsingSegue:kStartToPasswordSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<PasswordModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

- (void) openWalletAnimated:(BOOL)animated {
  if (animated) {
    NSString *segueIdentifier = kStartToHomeSegueIdentifier;
    [[self.transitionHandler openModuleUsingSegue:segueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<HomeModuleInput> moduleInput) {
      [moduleInput configureModuleForNewWallet:YES];
      return nil;
    }];
  } else {
    [[self.transitionHandler openModuleUsingFactory:self.homeFactory
                                withTransitionBlock:^(id<RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler, id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
                                  UIViewController *fromViewController = (UIViewController *)sourceModuleTransitionHandler;
                                  UIViewController *toViewController = (UIViewController *)destinationModuleTransitionHandler;
                                  
                                  UINavigationController *navigationController = [fromViewController navigationController];
                                  NSArray <__kindof UIViewController *> *viewControllers = [navigationController.viewControllers arrayByAddingObject:toViewController];
                                  [navigationController setViewControllers:viewControllers animated:NO];
                                }] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<HomeModuleInput> moduleInput) {
                                  [moduleInput configureModuleForNewWallet:YES];
                                  return nil;
                                }];
  }
}

- (void) openRestoreWallet {
  [[self.transitionHandler openModuleUsingSegue:kStartToRestoreOptionsSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RestoreOptionsModuleInput> moduleInput) {
    [moduleInput configureModuleWhileForgotPassword:NO];
    return nil;
  }];
}

@end
