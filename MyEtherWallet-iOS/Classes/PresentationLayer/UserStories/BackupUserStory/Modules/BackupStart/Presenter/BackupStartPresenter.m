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

@implementation BackupStartPresenter

#pragma mark - BackupStartModuleInput

- (void) configureModule {
}

#pragma mark - BackupStartViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) startAction {
  [self.router openWords];
}

#pragma mark - BackupStartInteractorOutput

@end
