//
//  StartPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "StartPresenter.h"

#import "StartViewInput.h"
#import "StartInteractorInput.h"
#import "StartRouterInput.h"

@implementation StartPresenter

#pragma mark - StartModuleInput

- (void) configureModule {
}

- (void) configurateForCreatedWalletWithAddress:(NSString *)address {
  [self.router openWalletWithAddress:address animated:NO];
}

#pragma mark - StartViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void)createNewWalletAction {
  [self.router openCreateNewWallet];
}

- (void) restoreWallet {
  [self.router openRestoreWallet];
}

#pragma mark - StartInteractorOutput

@end
