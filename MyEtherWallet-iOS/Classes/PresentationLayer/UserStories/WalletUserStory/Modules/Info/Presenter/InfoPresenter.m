//
//  InfoPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "InfoPresenter.h"

#import "InfoViewInput.h"
#import "InfoInteractorInput.h"
#import "InfoRouterInput.h"

@implementation InfoPresenter

#pragma mark - InfoModuleInput

- (void) configureModule {
}

#pragma mark - InfoViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) closeAction {
  [self.router close];
}

- (void) contactAction {
  
}

- (void) knowledgeBaseAction {
  
}

- (void) privacyAndTermsAction {
  
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

#pragma mark - InfoInteractorOutput

@end
