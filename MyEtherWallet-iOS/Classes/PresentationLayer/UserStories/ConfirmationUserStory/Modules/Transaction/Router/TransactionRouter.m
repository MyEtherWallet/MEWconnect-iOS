//
//  TransactionRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "TransactionRouter.h"

#import "SplashPasswordModuleInput.h"
#import "SplashPasswordModuleOutput.h"

static NSString *const kTransactionToDeclinedTransactionSegueIdentifier = @"TransactionToDeclinedTransactionSegueIdentifier";
static NSString *const kTransactionToConfirmedTransactionSegueIdentifier = @"TransactionToConfirmedTransactionSegueIdentifier";
static NSString *const kTransactionToSplashPasswordSegueIdentifier = @"TransactionToSplashPasswordSegueIdentifier";

@implementation TransactionRouter

#pragma mark - TransactionRouterInput

- (void) openConfirmedTransaction {
  [[self.transitionHandler openModuleUsingSegue:kTransactionToConfirmedTransactionSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerViperModuleInput> moduleInput) {
    return nil;
  }];
}

- (void) openDeclinedTransaction {
  [[self.transitionHandler openModuleUsingSegue:kTransactionToDeclinedTransactionSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerViperModuleInput> moduleInput) {
    return nil;
  }];
}

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) openSplashPasswordWithOutput:(id <SplashPasswordModuleOutput>)output {
  [[self.transitionHandler openModuleUsingSegue:kTransactionToSplashPasswordSegueIdentifier] thenChainUsingBlock:^id<SplashPasswordModuleOutput>(id<SplashPasswordModuleInput> moduleInput) {
    [moduleInput configureModule];
    return output;
  }];
}

@end
