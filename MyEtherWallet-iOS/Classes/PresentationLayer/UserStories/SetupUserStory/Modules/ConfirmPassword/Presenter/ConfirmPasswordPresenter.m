//
//  ConfirmPasswordPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmPasswordPresenter.h"

#import "ConfirmPasswordViewInput.h"
#import "ConfirmPasswordInteractorInput.h"
#import "ConfirmPasswordRouterInput.h"

@implementation ConfirmPasswordPresenter {
  BOOL _forgotPassword;
}

#pragma mark - ConfirmPasswordModuleInput

- (void) configureModuleWithPassword:(NSString *)password words:(NSArray<NSString *> *)words forgotPassword:(BOOL)forgotPassword {
  _forgotPassword = forgotPassword;
  [self.interactor configurateWithPassword:password words:words];
}

#pragma mark - ConfirmPasswordViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) passwordDidChanged:(NSString *)password {
  [self.interactor complareConfirmationPassword:password];
}

- (void) nextActionWithPassword:(NSString *)password {
  [self.interactor confirmPasswordWithPassword:password];
}

#pragma mark - ConfirmPasswordInteractorOutput

- (void) emptyConfirmationPassword {
  [self.view showValidPasswordInput];
  [self.view disableNext];
}

- (void) correctPasswords {
  [self.view showValidPasswordInput];
  [self.view enableNext];
}

- (void) incorrectPassword:(BOOL)error {
  if (error) {
    [self.view showInvalidPasswordInput];
  } else {
    [self.view showValidPasswordInput];
  }
  [self.view disableNext];
}

- (void) prepareWalletWithPassword:(NSString *)password words:(NSArray<NSString *> *)words {
  [self.router openNewWalletWithPassword:password words:words forgotPassword:_forgotPassword];
}

@end
