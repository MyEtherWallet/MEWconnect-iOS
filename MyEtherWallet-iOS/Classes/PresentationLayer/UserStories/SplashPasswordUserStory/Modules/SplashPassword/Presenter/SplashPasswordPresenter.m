//
//  SplashPasswordPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordPresenter.h"

#import "SplashPasswordViewInput.h"
#import "SplashPasswordInteractorInput.h"
#import "SplashPasswordRouterInput.h"

#import "SplashPasswordModuleOutput.h"

@implementation SplashPasswordPresenter {
  BOOL _control;
}

#pragma mark - SplashPasswordModuleInput

- (void) configureModuleWithAccount:(AccountPlainObject *)account autoControl:(BOOL)autoControl {
  _control = autoControl;
  [self.interactor configurateWithAccount:account];
}

- (void) takeControlAfterLaunch {
  _control = YES;
  [self.view becomePasswordInputActive];
}

#pragma mark - SplashPasswordViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialStateWithAutoControl:_control];
}

- (void) doneActionWithPassword:(NSString *)password {
  [self.interactor checkPassword:password];
}

- (void) forgotPasswordAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openForgotPasswordWithAccount:account];
}

#pragma mark - SplashPasswordInteractorOutput

- (void) correctPassword:(NSString *)password {
  [self.moduleOutput passwordDidEntered:password];
  [self.router close];
}

- (void) incorrectPassword {
  [self.view shakeInput];
}

@end
