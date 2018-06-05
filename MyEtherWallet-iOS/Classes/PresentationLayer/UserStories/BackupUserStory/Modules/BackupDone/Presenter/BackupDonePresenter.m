//
//  BackupDonePresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupDonePresenter.h"

#import "BackupDoneViewInput.h"
#import "BackupDoneInteractorInput.h"
#import "BackupDoneRouterInput.h"

@implementation BackupDonePresenter

#pragma mark - BackupDoneModuleInput

- (void) configureModule {
}

#pragma mark - BackupDoneViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) doneAction {
  [self.router unwindToHome];
}

#pragma mark - BackupDoneInteractorOutput

@end
