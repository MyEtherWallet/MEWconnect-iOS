//
//  RestorePreparePresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestorePreparePresenter.h"

#import "RestorePrepareViewInput.h"
#import "RestorePrepareInteractorInput.h"
#import "RestorePrepareRouterInput.h"

@implementation RestorePreparePresenter {
  BOOL _forgotPassword;
}

#pragma mark - RestorePrepareModuleInput

- (void) configureModuleWhileForgotPassword:(BOOL)forgotPassword {
  _forgotPassword = forgotPassword;
}

#pragma mark - RestorePrepareViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) continueAction {
  [self.router openRestoreWalletWhileForgotPassword:_forgotPassword];
}

#pragma mark - RestorePrepareInteractorOutput

@end
