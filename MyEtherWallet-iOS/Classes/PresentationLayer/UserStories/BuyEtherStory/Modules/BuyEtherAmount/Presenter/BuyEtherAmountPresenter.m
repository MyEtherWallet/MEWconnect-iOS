//
//  BuyEtherAmountPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherAmountPresenter.h"

#import "BuyEtherAmountViewInput.h"
#import "BuyEtherAmountInteractorInput.h"
#import "BuyEtherAmountRouterInput.h"

@implementation BuyEtherAmountPresenter

#pragma mark - BuyEtherAmountModuleInput

- (void) configureModuleWithAccount:(AccountPlainObject *)account {
  [self.interactor configurateWithAccount:account];
}

#pragma mark - BuyEtherAmountViewOutput

- (void) didTriggerViewReadyEvent {
  SimplexServiceCurrencyType currency = [self.interactor obtainCurrencyType];
  NSDecimalNumber *minimumAmount = [self.interactor obtainMinimumAmount];
	[self.view setupInitialStateWithCurrency:currency minimumAmount:minimumAmount];
  NSString *enteredAmount = [self.interactor obtainEnteredAmount];
  NSDecimalNumber *convertedAmount = [self.interactor obtainConvertedAmount];
  [self.view updateWithEnteredAmount:enteredAmount convertedAmount:convertedAmount];
}

- (void) didEnterSymbolAction:(NSString *)symbol {
  [self.interactor appendSymbol:symbol];
}

- (void) eraseSymbolAction {
  [self.interactor eraseSymbol];
}

- (void) closeAction {
  [self.router close];
}

- (void) historyAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openBuyEtherHistoryForAccount:account];
}

- (void) buyAction {
  [self.interactor prepareQuote];
}

- (void) switchConvertingAction {
  [self.interactor switchConverting];
  SimplexServiceCurrencyType currency = [self.interactor obtainCurrencyType];
  [self.view updateCurrency:currency];
  NSString *enteredAmount = [self.interactor obtainEnteredAmount];
  NSDecimalNumber *convertedAmount = [self.interactor obtainConvertedAmount];
  [self.view updateWithEnteredAmount:enteredAmount convertedAmount:convertedAmount];
}

#pragma mark - BuyEtherAmountInteractorOutput

- (void) updateInputPriceWithEnteredAmount:(NSString *)enteredAmount convertedAmount:(NSDecimalNumber *)convertedAmount {
  [self.view updateWithEnteredAmount:enteredAmount convertedAmount:convertedAmount];
}

- (void)orderDidCreated:(SimplexOrder *)order forAccount:(AccountPlainObject *)account {
  [self.router openBuyEtherWebWithOrder:order account:account];
}

- (void) minimumAmountDidReached:(BOOL)minimumAmountReached {
  if (minimumAmountReached) {
    [self.view enableContinue];
  } else {
    [self.view disableContinue];
  }
}

@end
