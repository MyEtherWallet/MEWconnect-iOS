//
//  MessageSignerRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "MessageSignerRouter.h"

#import "ContextPasswordModuleInput.h"
#import "ContextPasswordModuleOutput.h"
#import "ConfirmationStoryModuleOutput.h"
#import "ConfirmedTransactionModuleInput.h"

static NSString *const kMessageToConfirmedTransactionSegueIdentifier = @"MessageToConfirmedTransactionSegueIdentifier";
static NSString *const kMessageToContextPasswordSegueIdentifier = @"MessageToContextPasswordSegueIdentifier";

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

- (void) openContextPasswordWithAccount:(AccountPlainObject *)account moduleOutput:(id<ContextPasswordModuleOutput>)output {
  [[self.transitionHandler openModuleUsingSegue:kMessageToContextPasswordSegueIdentifier] thenChainUsingBlock:^id<ContextPasswordModuleOutput>(id<ContextPasswordModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account type:ContextPasswordTypeMessage];
    return output;
  }];
}

@end
