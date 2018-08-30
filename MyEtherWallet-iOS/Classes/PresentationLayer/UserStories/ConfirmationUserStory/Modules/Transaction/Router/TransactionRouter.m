//
//  TransactionRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "TransactionRouter.h"

#import "SplashPasswordModuleInput.h"
#import "SplashPasswordModuleOutput.h"
#import "ConfirmationStoryModuleOutput.h"

#import "ConfirmedTransactionModuleInput.h"

static NSString *const kTransactionToDeclinedTransactionSegueIdentifier = @"TransactionToDeclinedTransactionSegueIdentifier";
static NSString *const kTransactionToConfirmedTransactionSegueIdentifier = @"TransactionToConfirmedTransactionSegueIdentifier";
static NSString *const kTransactionToSplashPasswordSegueIdentifier = @"TransactionToSplashPasswordSegueIdentifier";

@implementation TransactionRouter

#pragma mark - TransactionRouterInput

- (void) openConfirmedTransactionWithConfirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate {
  [[self.transitionHandler openModuleUsingSegue:kTransactionToConfirmedTransactionSegueIdentifier] thenChainUsingBlock:^id<ConfirmationStoryModuleOutput>(id<ConfirmedTransactionModuleInput> moduleInput) {
    [moduleInput configureModuleForTransaction];
    return confirmationDelegate;
  }];
}

- (void) openDeclinedTransactionWithConfirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate {
  [[self.transitionHandler openModuleUsingSegue:kTransactionToDeclinedTransactionSegueIdentifier] thenChainUsingBlock:^id<ConfirmationStoryModuleOutput>(id<RamblerViperModuleInput> moduleInput) {
    return confirmationDelegate;
  }];
}

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) openSplashPasswordWithAccount:(AccountPlainObject *)account moduleOutput:(id<SplashPasswordModuleOutput>)output {
  [[self.transitionHandler openModuleUsingSegue:kTransactionToSplashPasswordSegueIdentifier] thenChainUsingBlock:^id<SplashPasswordModuleOutput>(id<SplashPasswordModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account autoControl:YES];
    return output;
  }];
}

@end
