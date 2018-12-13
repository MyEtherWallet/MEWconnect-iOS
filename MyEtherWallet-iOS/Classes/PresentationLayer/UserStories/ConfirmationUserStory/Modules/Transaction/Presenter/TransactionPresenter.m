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

#import "ContextPasswordModuleOutput.h"

@interface TransactionPresenter () <ContextPasswordModuleOutput>
@end

@implementation TransactionPresenter {
  BOOL _addressConfirmed;
  BOOL _amountConfirmer;
}

#pragma mark - TransactionModuleInput

- (void) configureModuleWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken {
  [self.interactor configurateWithMessage:command masterToken:masterToken];
}

#pragma mark - TransactionViewOutput

- (void) didTriggerViewReadyEvent {
  [self.view setupInitialState];
  MEWConnectTransaction *transaction = [self.interactor obtainTransaction];
  [self.view updateWithTransaction:transaction];
}

- (void) signAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openContextPasswordWithAccount:account moduleOutput:self];
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

- (void) transactionDidSigned:(__unused MEWConnectResponse *)response {
  [self.router openConfirmedTransactionWithConfirmationDelegate:self.moduleOutput];
}

#pragma mark - ContextPasswordModuleOutput

- (void) passwordDidEntered:(NSString *)password {
  [self.interactor signTransactionWithPassword:password];
}

@end
