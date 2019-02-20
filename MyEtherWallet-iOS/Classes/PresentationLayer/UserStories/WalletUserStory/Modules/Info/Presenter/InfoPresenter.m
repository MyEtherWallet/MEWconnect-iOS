//
//  InfoPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoPresenter.h"

#import "InfoViewInput.h"
#import "InfoInteractorInput.h"
#import "InfoRouterInput.h"

#import "ContextPasswordModuleOutput.h"

#import "ApplicationConstants.h"

#import "NSBundle+Version.h"

@interface InfoPresenter () <ContextPasswordModuleOutput>
@end

@implementation InfoPresenter

#pragma mark - InfoModuleInput

- (void) configureModuleWithAccount:(AccountPlainObject *)account {
  [self.interactor configureWithAccount:account];
}

- (void) configureAccountBackupStatus {
  [self.interactor accountBackedUp];
  BOOL isBackupAvailable = [self.interactor isBackupAvailable];
  BOOL isBackedUp = [self.interactor isBackedUp];
  [self.view updateWithBackupAvailability:isBackupAvailable backupStatus:isBackedUp];
}

#pragma mark - InfoViewOutput

- (void) didTriggerViewReadyEvent {
  NSString *version = [[NSBundle mainBundle] applicationVersion];
  BOOL isBackedUp = [self.interactor isBackedUp];
  BOOL isBackupAvailable = [self.interactor isBackupAvailable];
  [self.view setupInitialStateWithVersion:version backupAvailability:isBackupAvailable backedStatus:isBackedUp];
}

- (void) closeAction {
  [self.router close];
}

- (void) contactAction {
  NSString *version = [[NSBundle mainBundle] applicationVersion];
  NSString *subject = [NSString stringWithFormat:@"MEWconnect v.%@ support request", version];
  NSArray *recipients = @[kMyEtherWalletSupportEmail];
  [self.view presentMailComposeWithSubject:subject recipients:recipients];
}

- (void) knowledgeBaseAction {
  [self.router openKnowledgeBase];
}

- (void) privacyAndTermsAction {
  [self.router openPrivacyAndTerms];
}

- (void) myEtherWalletComAction {
  [self.router openMyEtherWalletCom];
}

- (void) resetWalletAction {
  [self.view presentResetConfirmation];
}

- (void) resetWalletConfirmedAction {
  [self.interactor resetWallet];
  [self.router unwindToStart];
}

- (void) userGuideAction {
  [self.router openUserGuide];
}

- (void) aboutAction {
  [self.router openAbout];
}

- (void) viewBackupPhraseAction {  
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openContextPasswordWithOutput:self account:account];
}

- (void) makeBackupAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openBackupWithAccount:account];
}

#pragma mark - InfoInteractorOutput

- (void) mnemonicsDidReceived:(NSArray <NSString *> *)mnemonics {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.router openWordsWithMnemonics:mnemonics];
  });
}

#pragma mark - ContextPasswordModuleOutput

- (void)passwordDidEntered:(NSString *)password {
  [self.interactor passwordDidEntered:password];
}

@end
