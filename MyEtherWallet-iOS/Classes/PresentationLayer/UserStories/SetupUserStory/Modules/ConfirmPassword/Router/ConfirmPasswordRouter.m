//
//  ConfirmPasswordRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ConfirmPasswordRouter.h"

#import "NewWalletModuleInput.h"

static NSString *const kConfirmPasswordToNewWalletSegueIdentifier = @"ConfirmPasswordToNewWalletSegueIdentifier";

@implementation ConfirmPasswordRouter

#pragma mark - ConfirmPasswordRouterInput

- (void) openNewWalletWithPassword:(NSString *)password words:(NSArray<NSString *> *)words forgotPassword:(BOOL)forgotPassword {
  [[self.transitionHandler openModuleUsingSegue:kConfirmPasswordToNewWalletSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<NewWalletModuleInput> moduleInput) {
    [moduleInput configureModuleWithPassword:password words:words forgotPassword:forgotPassword];
    return nil;
  }];
}

@end
