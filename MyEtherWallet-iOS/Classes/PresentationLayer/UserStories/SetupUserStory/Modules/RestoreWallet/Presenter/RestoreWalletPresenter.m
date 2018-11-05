//
//  RestoreWalletPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreWalletPresenter.h"

#import "RestoreWalletViewInput.h"
#import "RestoreWalletInteractorInput.h"
#import "RestoreWalletRouterInput.h"

@implementation RestoreWalletPresenter {
  BOOL _forgotPassword;
}

#pragma mark - RestoreWalletModuleInput

- (void) configureModuleWhileForgotPassword:(BOOL)forgotPassword {
  _forgotPassword = forgotPassword;
  [self.interactor configurate];
}

#pragma mark - RestoreWalletViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) cancelAction {
  [self.router close];
}

- (void) nextAction {
  [self.interactor tryRestore];
}

- (void) textDidChangedAction:(NSString *)text {
  [self.interactor checkMnemonics:text];
}

#pragma mark - RestoreWalletInteractorOutput

- (void) allowRestore {
  [self.view enableNext:YES];
}

- (void) disallowRestore {
  [self.view enableNext:NO];
}

- (void) restoreNotPossible {
  [self.view presentIncorrectMnemonicsWarning];
}

- (void) openPasswordWithWords:(NSArray <NSString *> *)words {
  [self.router openPasswordWithWords:words forgotPassword:_forgotPassword];
}

@end
