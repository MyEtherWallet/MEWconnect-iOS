//
//  SplashPasswordRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "SplashPasswordRouter.h"
#import "ForgotPasswordModuleInput.h"

static NSString *const kSplashPasswordToForgotPasswordSegueIdentifier = @"SplashPasswordToForgotPasswordSegueIdentifier";

@implementation SplashPasswordRouter

#pragma mark - SplashPasswordRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) openForgotPasswordWithAccount:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kSplashPasswordToForgotPasswordSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<ForgotPasswordModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account];
    return nil;
  }];
}

@end
