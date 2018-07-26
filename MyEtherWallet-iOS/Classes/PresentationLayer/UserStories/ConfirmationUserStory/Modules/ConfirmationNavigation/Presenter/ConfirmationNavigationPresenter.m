//
//  ConfirmationNavigationPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmationNavigationPresenter.h"

#import "ConfirmationNavigationViewInput.h"
#import "ConfirmationNavigationRouterInput.h"

@implementation ConfirmationNavigationPresenter

#pragma mark - ConfirmationNavigationModuleInput

- (void) configureModule {
}

- (void) closeWithCompletion:(ModuleCloseCompletionBlock)completion {
  [self.router closeWithCompletion:completion];
}

#pragma mark - ConfirmationNavigationViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

@end
