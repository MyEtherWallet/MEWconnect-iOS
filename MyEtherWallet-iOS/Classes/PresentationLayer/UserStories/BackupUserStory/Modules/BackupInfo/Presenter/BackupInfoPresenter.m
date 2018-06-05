//
//  BackupInfoPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupInfoPresenter.h"

#import "BackupInfoViewInput.h"
#import "BackupInfoInteractorInput.h"
#import "BackupInfoRouterInput.h"

@implementation BackupInfoPresenter

#pragma mark - BackupInfoModuleInput

- (void) configureModule {
}

#pragma mark - BackupInfoViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void)startAction {
  [self.router openBackupStart];
}

- (void)cancelAction {
  [self.router close];
}

#pragma mark - BackupInfoInteractorOutput

@end
