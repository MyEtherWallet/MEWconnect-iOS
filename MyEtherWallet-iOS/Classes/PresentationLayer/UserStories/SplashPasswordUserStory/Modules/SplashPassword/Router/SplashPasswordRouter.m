//
//  SplashPasswordRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "SplashPasswordRouter.h"

static NSString *const kSplashPasswordToForgotPasswordSegueIdentifier = @"SplashPasswordToForgotPasswordSegueIdentifier";

@implementation SplashPasswordRouter

#pragma mark - SplashPasswordRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) openForgotPassword {
  [[self.transitionHandler openModuleUsingSegue:kSplashPasswordToForgotPasswordSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerViperModuleInput> moduleInput) {
    return nil;
  }];
}

@end
