//
//  TransactionPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TransactionPresenter.h"

#import "TransactionViewInput.h"
#import "TransactionInteractorInput.h"
#import "TransactionRouterInput.h"

#import "SplashPasswordModuleOutput.h"

@interface TransactionPresenter () <SplashPasswordModuleOutput>
@end

@implementation TransactionPresenter {
  BOOL _addressConfirmed;
  BOOL _amountConfirmer;
}

#pragma mark - TransactionModuleInput

- (void) configureModuleWithMessage:(MEWConnectCommand *)command {
  [self.interactor configurateWithMessage:command];
}

#pragma mark - TransactionViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
  MEWConnectTransaction *transaction = [self.interactor obtainTransaction];
  [self.view updateWithTransaction:transaction];
}

- (void) signAction {
  [self.router openSplashPasswordWithOutput:self];
}

- (void) declineAction {
  [self.router openDeclinedTransaction];
}

- (void)confirmAddressAction:(BOOL)confirmed {
  _addressConfirmed = confirmed;
  [self.view enableSign:_addressConfirmed && _amountConfirmer];
}

- (void)confirmAmountAction:(BOOL)confirmed {
  _amountConfirmer = confirmed;
  [self.view enableSign:_addressConfirmed && _amountConfirmer];
}

#pragma mark - TransactionInteractorOutput

- (void) transactionDidSigned:(MEWConnectResponse *)response {
  [self.router openConfirmedTransaction];
}

#pragma mark - SplashPasswordModuleOutput

- (void)passwordDidEntered:(NSString *)password {
  [self.interactor signTransactionWithPassword:password];
}

@end
