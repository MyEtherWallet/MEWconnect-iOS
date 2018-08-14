//
//  ForgotPasswordRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ForgotPasswordRouter.h"

#import "RestoreWalletModuleInput.h"
#import "StartModuleInput.h"

static NSString *const kForgotPasswordToRestoreWalletSegueIdentifier = @"ForgotPasswordToRestoreWalletSegueIdentifier";
static NSString *const kForgotPasswordToStartUnwindSegueIdentifier   = @"ForgotPasswordToStartUnwindSegueIdentifier";

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

- (void) unwindToStart {
  [[self.transitionHandler openModuleUsingSegue:kForgotPasswordToStartUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<StartModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

@end
