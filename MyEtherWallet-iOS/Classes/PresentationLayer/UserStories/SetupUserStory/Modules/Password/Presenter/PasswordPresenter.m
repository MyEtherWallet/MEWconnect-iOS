//
//  PasswordPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "PasswordPresenter.h"

#import "PasswordViewInput.h"
#import "PasswordInteractorInput.h"
#import "PasswordRouterInput.h"

@implementation PasswordPresenter {
  BOOL _forgotPassword;
}

#pragma mark - PasswordModuleInput

- (void) configureModule {
  [self.interactor configureWithWords:nil];
}

- (void)configureModuleWithWords:(NSArray <NSString *> *)words forgotPassword:(BOOL)forgotPassword {
  _forgotPassword = forgotPassword;
  [self.interactor configureWithWords:words];
}

#pragma mark - PasswordViewOutput

- (void) didTriggerViewReadyEvent {
  BOOL wordsProvided = [self.interactor isWordsProvided];
  [self.view setupInitialStateWithBackButton:!wordsProvided];
}

- (void)passwordDidChanged:(NSString *)password {
  if ([password length] > 0) {
    [self.view showCrackMeterIfNeeded];
    [self.interactor scorePassword:password];
  } else {
    [self.view hideCrackMeter];
  }
}

- (void) cancelAction {
  [self.router close];
}

- (void) nextAction {
  [self.interactor confirmPassword];
}

#pragma mark - PasswordInteractorOutput

- (void)updateScore:(int)score {
  [self.view updateScore:(PasswordScoreTheme)score animated:YES];
}

- (void) confirmPassword:(NSString *)password words:(NSArray<NSString *> *)words {
  [self.router openConfirmationWithPassword:password words:words forgotPassword:_forgotPassword];
}

@end
