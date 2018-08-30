//
//  MessageSignerRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "MessageSignerRouter.h"

#import "SplashPasswordModuleInput.h"
#import "SplashPasswordModuleOutput.h"
#import "ConfirmationStoryModuleOutput.h"
#import "ConfirmedTransactionModuleInput.h"

static NSString *const kMessageToConfirmedTransactionSegueIdentifier = @"MessageToConfirmedTransactionSegueIdentifier";
static NSString *const kMessageToSplashPasswordSegueIdentifier = @"MessageToSplashPasswordSegueIdentifier";

@implementation MessageSignerRouter

#pragma mark - MessageSignerRouterInput

- (void) openConfirmedMessageWithConfirmationDelegate:(id<ConfirmationStoryModuleOutput>)confirmationDelegate {
  [[self.transitionHandler openModuleUsingSegue:kMessageToConfirmedTransactionSegueIdentifier] thenChainUsingBlock:^id<ConfirmationStoryModuleOutput>(id<ConfirmedTransactionModuleInput> moduleInput) {
    [moduleInput configureModuleForMessage];
    return confirmationDelegate;
  }];
}

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) openSplashPasswordWithAccount:(AccountPlainObject *)account moduleOutput:(id<SplashPasswordModuleOutput>)output {
  [[self.transitionHandler openModuleUsingSegue:kMessageToSplashPasswordSegueIdentifier] thenChainUsingBlock:^id<SplashPasswordModuleOutput>(id<SplashPasswordModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account autoControl:YES];
    return output;
  }];
}

@end
