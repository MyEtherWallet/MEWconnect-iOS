//
//  BackupConfirmationPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationPresenter.h"

#import "BackupConfirmationViewInput.h"
#import "BackupConfirmationInteractorInput.h"
#import "BackupConfirmationRouterInput.h"

@implementation BackupConfirmationPresenter

#pragma mark - BackupConfirmationModuleInput

- (void) configureModuleWithMnemonics:(NSArray<NSString *> *)mnemonics {
  [self.interactor configurateWithMnemonics:mnemonics];
}

#pragma mark - BackupConfirmationViewOutput

- (void) didTriggerViewReadyEvent {
  BackupConfirmationQuiz *quiz = [self.interactor obtainRecoveryQuiz];
	[self.view setupInitialStateWithQuiz:quiz];
}

- (void) didSelectAnswers:(NSArray <NSString *> *)vector {
  [self.interactor checkVector:vector];
}

- (void) finishAction {
  [self.interactor walletBackedUp];
  [self.router openDone];
}

#pragma mark - BackupConfirmationInteractorOutput

- (void) vectorDidChecked:(BOOL)correct {
  [self.view enableFinish:correct];
}

@end
