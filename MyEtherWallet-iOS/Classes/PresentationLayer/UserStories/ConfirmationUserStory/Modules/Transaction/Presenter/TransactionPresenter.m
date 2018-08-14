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

- (void) configureModuleWithMessage:(MEWConnectCommand *)command account:(AccountPlainObject *)account {
  [self.interactor configurateWithMessage:command account:account];
}

#pragma mark - TransactionViewOutput

- (void) didTriggerViewReadyEvent {
	[self.view setupInitialState];
  AccountPlainObject *account = [self.interactor obtainAccount];
  MEWConnectTransaction *transaction = [self.interactor obtainTransaction];
  [self.view updateWithTransaction:transaction forAccount:account];
}

- (void) signAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openSplashPasswordWithAccount:account moduleOutput:self];
}

- (void) declineAction {
  [self.router openDeclinedTransactionWithConfirmationDelegate:self.moduleOutput];
}

- (void) confirmAddressAction:(BOOL)confirmed {
  _addressConfirmed = confirmed;
  [self.view enableSign:_addressConfirmed && _amountConfirmer];
}

- (void) confirmAmountAction:(BOOL)confirmed {
  _amountConfirmer = confirmed;
  [self.view enableSign:_addressConfirmed && _amountConfirmer];
}

#pragma mark - TransactionInteractorOutput

- (void) transactionDidSigned:(MEWConnectResponse *)response {
  [self.router openConfirmedTransactionWithConfirmationDelegate:self.moduleOutput];
}

#pragma mark - SplashPasswordModuleOutput

- (void) passwordDidEntered:(NSString *)password {
  [self.interactor signTransactionWithPassword:password];
}

@end
