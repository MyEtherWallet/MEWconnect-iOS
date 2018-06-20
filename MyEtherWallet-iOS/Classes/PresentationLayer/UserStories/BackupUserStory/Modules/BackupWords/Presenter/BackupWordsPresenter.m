//
//  BackupWordsPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupWordsPresenter.h"

#import "BackupWordsViewInput.h"
#import "BackupWordsInteractorInput.h"
#import "BackupWordsRouterInput.h"

@implementation BackupWordsPresenter

#pragma mark - BackupWordsModuleInput

- (void) configureModuleWithMnemonics:(NSArray<NSString *> *)mnemonics {
  [self.interactor configurateWithMnemonics:mnemonics];
}

#pragma mark - BackupWordsViewOutput

- (void) didTriggerViewReadyEvent {
  NSArray *mnemonics = [self.interactor recoveryMnemonicsWords];
  [self.view setupInitialStateWithWords:mnemonics];
}

- (void) nextAction {
  NSArray *mnemonics = [self.interactor recoveryMnemonicsWords];
  [self.router openConfirmationWithMnemonics:mnemonics];
}

- (void) didTriggerViewWillAppearEvent {
  [self.interactor subscribeToEvents];
}

- (void) didTriggerViewWillDisappearEvent {
  [self.interactor unsubscribeFromEvents];
}

#pragma mark - BackupWordsInteractorOutput

- (void) userDidTakeScreenshot {
  [self.view showScreenshotAlert];
}

@end
