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

@implementation SplashPasswordPresenter

#pragma mark - SplashPasswordModuleInput

- (void) configureModuleWithAccount:(AccountPlainObject *)account {
  [self.interactor configurateWithAccount:account];
}

#pragma mark - SplashPasswordViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
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
