//
//  RestoreOptionsPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreOptionsPresenter.h"

#import "RestoreOptionsViewInput.h"
#import "RestoreOptionsInteractorInput.h"
#import "RestoreOptionsRouterInput.h"

@implementation RestoreOptionsPresenter {
  BOOL _forgotPassword;
}

#pragma mark - RestoreOptionsModuleInput

- (void) configureModuleWhileForgotPassword:(BOOL)forgotPassword {
  _forgotPassword = forgotPassword;
}

#pragma mark - RestoreOptionsViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) closeAction {
  [self.router close];
}

- (void) otherOptionsAction {
  [self.router openRestoreSafery];
}

- (void) recoveryPhraseAction {
  [self.router openPrepareWhileForgotPassword:_forgotPassword];
}

#pragma mark - RestoreOptionsInteractorOutput

@end
