//
//  ContextPasswordPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ContextPasswordPresenter.h"

#import "ContextPasswordViewInput.h"
#import "ContextPasswordInteractorInput.h"
#import "ContextPasswordRouterInput.h"
#import "ContextPasswordModuleOutput.h"

@implementation ContextPasswordPresenter {
  ContextPasswordType _type;
}

#pragma mark - ContextPasswordModuleInput

- (void) configureModuleWithAccount:(AccountPlainObject *)account type:(ContextPasswordType)type {
  _type = type;
  [self.interactor configurateWithAccount:account];
}

#pragma mark - ContextPasswordViewOutput

- (void) didTriggerViewReadyEvent {
  NSString *title = nil;
  switch (_type) {
    case ContextPasswordTypeBackup: {
      title = NSLocalizedString(@"Enter password to start", @"Context inout password. Backup");
      break;
    }
    case ContextPasswordTypeMessage: {
      title = NSLocalizedString(@"Enter password to sign", @"Context inout password. Sign message");
      break;
    }
    case ContextPasswordTypeTransaction: {
      title = NSLocalizedString(@"Enter password to confirm", @"Context inout password. Sign transaction");
      break;
    }
    case ContextPasswordTypeGenerate: {
      title = NSLocalizedString(@"Enter password to generate", @"Context inout password. Generate new private key");
      break;
    }
      
    default:
      break;
  }
  [self.view setupInitialStateWithTitle:title];
}

- (void) cancelAction {
  [self.view prepareForDismiss];
  [self.router close:YES];
}

- (void) resignAction {
  [self.view prepareForDismiss];
  [self.router close:NO];
}

- (void) doneActionWithPassword:(NSString *)password {
  [self.interactor checkPassword:password];
}

#pragma mark - ContextPasswordInteractorOutput

- (void) correctPassword:(NSString *)password {
  [self.view prepareForDismiss];
  [self.moduleOutput passwordDidEntered:password];
  [self.router close:YES];
}

- (void) incorrectPassword {
  [self.view shakeInput];
}

@end
