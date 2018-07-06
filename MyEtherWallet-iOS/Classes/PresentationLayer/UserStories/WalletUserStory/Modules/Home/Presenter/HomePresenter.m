//
//  HomePresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomePresenter.h"

#import "HomeViewInput.h"
#import "HomeInteractorInput.h"
#import "HomeRouterInput.h"

#import "MessageSignerModuleOutput.h"

#import "MEWConnectCommand.h"

@implementation HomePresenter

#pragma mark - HomeModuleInput

- (void) configureModule {
  [self.interactor refreshAccount];
  [self.interactor configurate];
}

- (void) configureBackupStatus {
  [self.interactor refreshAccount];
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.view updateWithAccount:account];
}

- (void) configureAfterChangingNetwork {
  [self.interactor refreshAccount];
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.view updateWithAccount:account];
  
  NSUInteger count = [self.interactor obtainNumberOfTokens];
  NSDecimalNumber *tokensPrice = [self.interactor obtainTotalPriceOfTokens];
  [self.view updateWithTokensCount:count withTotalPrice:tokensPrice];
  
  [self.interactor reloadData];
}

#pragma mark - HomeViewOutput

- (void) didTriggerViewReadyEvent {
  NSUInteger count = [self.interactor obtainNumberOfTokens];
  NSDecimalNumber *tokensPrice = [self.interactor obtainTotalPriceOfTokens];
  [self.view setupInitialStateWithNumberOfTokens:count totalPrice:tokensPrice];
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.view updateWithAccount:account];
  
  BOOL connected = [self.interactor isConnected];
  [self.view updateWithConnectionStatus:connected animated:NO];
}

- (void) didTriggerViewWillAppear {
  [self.interactor subscribe];
  BOOL connected = [self.interactor isConnected];
  [self.view updateWithConnectionStatus:connected animated:NO];
}

- (void) didTriggerViewDidDisappear {
  [self.interactor unsubscribe];
}

- (void) connectAction {
  [self.router openScanner];
}

- (void) disconnectAction {
  [self.interactor disconnect];
  BOOL connected = [self.interactor isConnected];
  [self.view updateWithConnectionStatus:connected animated:YES];
}

- (void) didProcessCacheTransaction:(CacheTransactionBatch *)transactionBatch {
  [self.view updateWithTransactionBatch:transactionBatch];
}

- (void) backupAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openBackupWithAccount:account];
}

- (void) searchTermDidChanged:(NSString *)searchTerm {
  [self.interactor searchTokensWithTerm:searchTerm];
}

- (void) infoAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openInfoWithAccount:account];
}

- (void) buyEtherAction {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.router openBuyEtherWithAccount:account];
}

#pragma mark - HomeInteractorOutput

- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command {
  [self.router openMessageSignerWithMessage:command];
}

- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command account:(AccountPlainObject *)account {
  [self.router openTransactionSignerWithMessage:command account:account];
}

- (void) didUpdateTokens {
  NSUInteger count = [self.interactor obtainNumberOfTokens];
  NSDecimalNumber *tokensPrice = [self.interactor obtainTotalPriceOfTokens];
  [self.view updateWithTokensCount:count withTotalPrice:tokensPrice];
}

- (void)didUpdateTokensBalance {
  NSUInteger count = [self.interactor obtainNumberOfTokens];
  NSDecimalNumber *tokensPrice = [self.interactor obtainTotalPriceOfTokens];
  [self.view updateWithTokensCount:count withTotalPrice:tokensPrice];
}

- (void) didUpdateEthereumBalance {
  AccountPlainObject *account = [self.interactor obtainAccount];
  [self.view updateWithAccount:account];
}

- (void) mewConnectionStatusChanged {
  BOOL connected = [self.interactor isConnected];
  [self.view updateWithConnectionStatus:connected animated:YES];
}

@end
