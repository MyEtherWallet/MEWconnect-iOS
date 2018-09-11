//
//  ContextPasswordPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "ContextPasswordPresenter.h"

#import "ContextPasswordViewInput.h"
#import "ContextPasswordInteractorInput.h"
#import "ContextPasswordRouterInput.h"
#import "ContextPasswordModuleOutput.h"

@implementation ContextPasswordPresenter

#pragma mark - ContextPasswordModuleInput

- (void) configureModuleWithAccount:(AccountPlainObject *)account {
  [self.interactor configurateWithAccount:account];
}

#pragma mark - ContextPasswordViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) cancelAction {
  [self.view prepareForDismiss];
  [self.router close];
}

- (void) doneActionWithPassword:(NSString *)password {
  [self.interactor checkPassword:password];
}

#pragma mark - ContextPasswordInteractorOutput

- (void) correctPassword:(NSString *)password {
  [self.view prepareForDismiss];
  [self.moduleOutput passwordDidEntered:password];
  [self.router close];
}

- (void) incorrectPassword {
  [self.view shakeInput];
}

@end
