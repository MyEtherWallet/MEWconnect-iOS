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

#import "SplashPasswordModuleOutput.h"

@interface BackupStartPresenter () <SplashPasswordModuleOutput>
@end

@implementation BackupStartPresenter

#pragma mark - BackupStartModuleInput

- (void) configureModule {
}

#pragma mark - BackupStartViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) startAction {
  [self.router openSplashPasswordWithOutput:self];
}

#pragma mark - BackupStartInteractorOutput

- (void)mnemonicsDidReceived:(NSArray<NSString *> *)mnemonics {
  [self.router openWordsWithMnemonics:mnemonics];
}

#pragma mark - SplashPasswordModuleOutput

- (void) passwordDidEntered:(NSString *)password {
  [self.interactor passwordDidEntered:password];
}

@end
