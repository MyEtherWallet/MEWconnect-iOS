//
//  ForgotPasswordRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "ForgotPasswordRouter.h"

#import "RestoreWalletModuleInput.h"

static NSString *const kForgotPasswordToRestoreWalletSegueIdentifier = @"ForgotPasswordToRestoreWalletSegueIdentifier";

@implementation ForgotPasswordRouter

#pragma mark - ForgotPasswordRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) openRestore {
  [[self.transitionHandler openModuleUsingSegue:kForgotPasswordToRestoreWalletSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RestoreWalletModuleInput> moduleInput) {
    [moduleInput configureModuleWhileForgotPassword:YES];
    return nil;
  }];
}

@end
