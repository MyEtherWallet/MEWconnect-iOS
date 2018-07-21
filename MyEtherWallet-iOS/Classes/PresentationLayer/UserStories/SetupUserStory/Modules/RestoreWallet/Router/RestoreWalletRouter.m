//
//  RestoreWalletRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "RestoreWalletRouter.h"

#import "PasswordModuleInput.h"

static NSString *const kRestoreWalletToPasswordSegueIdentifier = @"RestoreWalletToPasswordSegueIdentifier";

@implementation RestoreWalletRouter

#pragma mark - RestoreWalletRouterInput

- (void)openPasswordWithWords:(NSArray <NSString *> *)words forgotPassword:(BOOL)forgotPassword {
  [[self.transitionHandler openModuleUsingSegue:kRestoreWalletToPasswordSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<PasswordModuleInput> moduleInput) {
    [moduleInput configureModuleWithWords:words forgotPassword:forgotPassword];
    return nil;
  }];
}

- (void)close {
  [self.transitionHandler closeCurrentModule:YES];
}

@end
