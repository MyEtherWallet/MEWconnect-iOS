//
//  ForgotPasswordPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ForgotPasswordPresenter.h"

#import "ForgotPasswordViewInput.h"
#import "ForgotPasswordInteractorInput.h"
#import "ForgotPasswordRouterInput.h"

@implementation ForgotPasswordPresenter

#pragma mark - ForgotPasswordModuleInput

- (void) configureModule {
}

#pragma mark - ForgotPasswordViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

#pragma mark - ForgotPasswordInteractorOutput

- (void)closeAction {
  [self.router close];
}

- (void)restoreAction {
  [self.router openRestore];
}

@end
