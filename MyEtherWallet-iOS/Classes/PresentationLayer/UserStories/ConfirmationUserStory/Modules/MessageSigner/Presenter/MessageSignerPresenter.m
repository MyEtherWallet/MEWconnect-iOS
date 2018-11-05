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

#import "ContextPasswordModuleOutput.h"

@interface MessageSignerPresenter () <ContextPasswordModuleOutput>
@end

@implementation MessageSignerPresenter

#pragma mark - MessageSignerModuleInput

- (void) configureModuleWithMessage:(MEWConnectCommand *)message masterToken:(MasterTokenPlainObject *)masterToken {
  [self.interactor configurateWithMessage:message masterToken:masterToken];
}

#pragma mark - MessageSignerViewOutput

- (void) didTriggerViewReadyEvent {
  [self.view setupInitialState];
  MEWConnectMessage *message = [self.interactor obtainMessage];
  [self.view updateWithMessage:message];
}

- (void) signAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openContextPasswordWithAccount:account moduleOutput:self];
}

- (void) declineAction {
  [self.router close];
}

#pragma mark - MessageSignerInteractorOutput

- (void) messageDidSigned:(__unused MEWConnectResponse *)response {
  [self.router openConfirmedMessageWithConfirmationDelegate:self.moduleOutput];
}

- (void) messageDidFailure {
  [self.router close];
}

#pragma mark - ContextPasswordModuleOutput

- (void) passwordDidEntered:(NSString *)password {
  [self.interactor signMessageWithPassword:password];
}

@end
