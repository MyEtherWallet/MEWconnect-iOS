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

@implementation MessageSignerPresenter

#pragma mark - MessageSignerModuleInput

- (void) configureModuleWithMessage:(MEWConnectCommand *)message {
  [self.interactor configurateWithMessage:message];
}

#pragma mark - MessageSignerViewOutput

- (void) didTriggerViewReadyEvent {
  NSString *message = [self.interactor obtainMessage];
	[self.view setupInitialState];
  [self.view updateMessage:message];
}

- (void) signAction {
  [self.interactor signMessage];
}

- (void) declineAction {
  [self.router close];
}

#pragma mark - MessageSignerInteractorOutput

- (void)messageDidSigned:(MEWConnectResponse *)response {
  [self.moduleOutput messageDidSigned:response];
  [self.router close];
}

@end
