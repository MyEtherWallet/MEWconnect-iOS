//
//  PasswordRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ConfirmPasswordModuleInput.h"

#import "PasswordRouter.h"

static NSString *const kPasswordToConfirmPasswordSegueIdentifier = @"PasswordToConfirmPasswordSegueIdentifier";

@implementation PasswordRouter

#pragma mark - PasswordRouterInput

- (void) openConfirmationWithPassword:(NSString *)password words:(NSArray<NSString *> *)words forgotPassword:(BOOL)forgotPassword {
  [[self.transitionHandler openModuleUsingSegue:kPasswordToConfirmPasswordSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<ConfirmPasswordModuleInput> moduleInput) {
    [moduleInput configureModuleWithPassword:password words:words forgotPassword:forgotPassword];
    return nil;
  }];
}

- (void)close {
  [self.transitionHandler closeCurrentModule:YES];
}

@end
