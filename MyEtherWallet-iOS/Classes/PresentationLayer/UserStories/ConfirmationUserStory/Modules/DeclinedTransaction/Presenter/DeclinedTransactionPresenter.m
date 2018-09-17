//
//  DeclinedTransactionPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "DeclinedTransactionPresenter.h"

#import "DeclinedTransactionViewInput.h"
#import "DeclinedTransactionInteractorInput.h"
#import "DeclinedTransactionRouterInput.h"

@implementation DeclinedTransactionPresenter

#pragma mark - DeclinedTransactionModuleInput

- (void) configureModule {
}

#pragma mark - DeclinedTransactionViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
}

- (void) closeAction {
  [self.moduleOutput transactionDidRejected];
}

#pragma mark - DeclinedTransactionInteractorOutput

@end
