//
//  BackupStartPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupStartPresenter.h"

#import "BackupStartViewInput.h"
#import "BackupStartInteractorInput.h"
#import "BackupStartRouterInput.h"

#import "ContextPasswordModuleOutput.h"

@interface BackupStartPresenter () <ContextPasswordModuleOutput>
@end

@implementation BackupStartPresenter

#pragma mark - BackupStartModuleInput

- (void) configureModuleWithAccount:(AccountPlainObject *)account {
  [self.interactor configurateWithAccount:account];
}

#pragma mark - BackupStartViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) startAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openContextPasswordWithOutput:self account:account];
}

#pragma mark - BackupStartInteractorOutput

- (void) mnemonicsDidReceived:(NSArray<NSString *> *)mnemonics {
  dispatch_async(dispatch_get_main_queue(), ^{
    AccountPlainObject *account = [self.interactor obtainAccount];
    [self.router openWordsWithMnemonics:mnemonics account:account];
  });
}

#pragma mark - ContextPasswordModuleOutput

- (void) passwordDidEntered:(NSString *)password {
  [self.interactor passwordDidEntered:password];
}

@end
