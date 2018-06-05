//
//  ConfirmedTransactionPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmedTransactionPresenter.h"

#import "ConfirmedTransactionViewInput.h"
#import "ConfirmedTransactionInteractorInput.h"
#import "ConfirmedTransactionRouterInput.h"

@implementation ConfirmedTransactionPresenter

#pragma mark - ConfirmedTransactionModuleInput

- (void) configureModule {
}

#pragma mark - ConfirmedTransactionViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) closeAction {
  [self.router close];
}

#pragma mark - ConfirmedTransactionInteractorOutput

@end
