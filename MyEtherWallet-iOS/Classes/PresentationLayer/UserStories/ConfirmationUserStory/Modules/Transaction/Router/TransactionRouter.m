//
//  TransactionRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "TransactionRouter.h"

#import "ContextPasswordModuleInput.h"
#import "ContextPasswordModuleOutput.h"
#import "ConfirmationStoryModuleOutput.h"

#import "ConfirmedTransactionModuleInput.h"
#import "DeclinedTransactionModuleInput.h"

static NSString *const kTransactionToDeclinedTransactionSegueIdentifier = @"TransactionToDeclinedTransactionSegueIdentifier";
static NSString *const kTransactionToConfirmedTransactionSegueIdentifier = @"TransactionToConfirmedTransactionSegueIdentifier";
static NSString *const kTransactionToContextPasswordSegueIdentifier = @"TransactionToContextPasswordSegueIdentifier";

@implementation TransactionRouter

#pragma mark - TransactionRouterInput

- (void) openConfirmedTransactionWithConfirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate {
  [[self.transitionHandler openModuleUsingSegue:kTransactionToConfirmedTransactionSegueIdentifier] thenChainUsingBlock:^id<ConfirmationStoryModuleOutput>(id<ConfirmedTransactionModuleInput> moduleInput) {
    [moduleInput configureModuleForTransaction];
    return confirmationDelegate;
  }];
}

- (void) openDeclinedTransactionWithConfirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate {
  [[self.transitionHandler openModuleUsingSegue:kTransactionToDeclinedTransactionSegueIdentifier] thenChainUsingBlock:^id<ConfirmationStoryModuleOutput>(id<DeclinedTransactionModuleInput> moduleInput) {
    [moduleInput configureModule];
    return confirmationDelegate;
  }];
}

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) openContextPasswordWithAccount:(AccountPlainObject *)account moduleOutput:(id<ContextPasswordModuleOutput>)output {
  [[self.transitionHandler openModuleUsingSegue:kTransactionToContextPasswordSegueIdentifier] thenChainUsingBlock:^id<ContextPasswordModuleOutput>(id<ContextPasswordModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account type:ContextPasswordTypeTransaction];
    return output;
  }];
}

@end
