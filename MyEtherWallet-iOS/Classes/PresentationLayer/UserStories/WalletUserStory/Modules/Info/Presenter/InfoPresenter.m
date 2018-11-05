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

#import "ApplicationConstants.h"

#import "NSBundle+Version.h"

@implementation InfoPresenter

#pragma mark - InfoModuleInput

- (void) configureModule {
}

#pragma mark - InfoViewOutput

- (void) didTriggerViewReadyEvent {
  NSString *version = [[NSBundle mainBundle] applicationVersion];
	[self.view setupInitialStateWithVersion:version];
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

@end
