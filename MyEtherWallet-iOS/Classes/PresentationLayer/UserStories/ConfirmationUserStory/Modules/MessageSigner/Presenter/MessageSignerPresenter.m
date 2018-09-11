//
//  MessageSignerPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MessageSignerPresenter.h"

#import "MessageSignerViewInput.h"
#import "MessageSignerInteractorInput.h"
#import "MessageSignerRouterInput.h"

#import "SplashPasswordModuleOutput.h"

@interface MessageSignerPresenter () <SplashPasswordModuleOutput>
@end

@implementation MessageSignerPresenter

#pragma mark - MessageSignerModuleInput

- (void) configureModuleWithMessage:(MEWConnectCommand *)message account:(AccountPlainObject *)account {
  [self.interactor configurateWithMessage:message account:account];
}

#pragma mark - MessageSignerViewOutput

- (void) didTriggerViewReadyEvent {
  [self.view setupInitialState];
  MEWConnectMessage *message = [self.interactor obtainMessage];
  [self.view updateWithMessage:message];
}

- (void) signAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openSplashPasswordWithAccount:account moduleOutput:self];
}

- (void) declineAction {
  [self.router close];
}

#pragma mark - MessageSignerInteractorOutput

- (void) messageDidSigned:(MEWConnectResponse *)response {
  [self.router openConfirmedMessageWithConfirmationDelegate:self.moduleOutput];
}

- (void) messageDidFailure {
  [self.router close];
}

#pragma mark - SplashPasswordModuleOutput

- (void) passwordDidEntered:(NSString *)password {
  [self.interactor signMessageWithPassword:password];
}

@end
