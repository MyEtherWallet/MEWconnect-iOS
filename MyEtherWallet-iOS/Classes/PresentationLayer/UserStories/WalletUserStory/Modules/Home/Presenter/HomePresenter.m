//
//  HomePresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "HomePresenter.h"

#import "HomeViewInput.h"
#import "HomeInteractorInput.h"
#import "HomeRouterInput.h"

#import "MessageSignerModuleOutput.h"

#import "MEWConnectCommand.h"

#import "ConfirmationNavigationModuleInput.h"
#import "ConfirmationStoryModuleOutput.h"

typedef NS_OPTIONS(short, HomeViewPresenterStatus) {
  HomeViewPresenterStatusUnknown              =   0 << 0,
  HomeViewPresenterStatusInternetConnection   =   1 << 0,
  HomeViewPresenterStatusMEWconnectConnection =   1 << 1,
};

@interface HomePresenter () <ConfirmationStoryModuleOutput>
@property (nonatomic, weak) id <ConfirmationNavigationModuleInput> transactionModuleInput;
@property (nonatomic) HomeViewPresenterStatus connectionStatus;
@end

@implementation HomePresenter {
  BOOL _tokensRefreshing;
}

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
  
  [self _refreshViewStatusAnimated:NO];
  if (_tokensRefreshing) {
    [self.view startAnimatingTokensRefreshing];
  }
}

- (void) didTriggerViewWillAppear {
  [self _refreshViewStatusAnimated:NO];
}

- (void) didTriggerViewDidDisappear {
}

- (void) connectAction {
  [self.router openScanner];
}

- (void) disconnectAction {
  [self.interactor disconnect];
  [self _refreshViewStatusAnimated:YES];
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

- (void) refreshTokensAction {
  [self.interactor refreshTokens];
}

- (void) shareAction {
  NSArray *items = [self.interactor shareActivityItems];
  [self.view presentShareWithItems:items];
}

- (void) networkAction {
  [self.view presentNetworkSelection];
}

- (void) mainnetAction {
  [self.interactor selectMainnetNetwork];
}

- (void) ropstenAction {
  [self.interactor selectRopstenNetwork];
}

#pragma mark - HomeInteractorOutput

- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command {
  [self.router openMessageSignerWithMessage:command];
}

- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command account:(AccountPlainObject *)account {
  if (self.transactionModuleInput) {
    @weakify(self);
    [self.transactionModuleInput closeWithCompletion:^{
      @strongify(self);
      self.transactionModuleInput = [self.router openTransactionSignerWithMessage:command account:account confirmationDelegate:self];
    }];
  } else {
    self.transactionModuleInput = [self.router openTransactionSignerWithMessage:command account:account confirmationDelegate:self];
  }
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
  [self.view updateEthereumBalanceWithAccount:account];
}

- (void) mewConnectionStatusChanged {
  BOOL connected = [self.interactor isConnected];
  if (connected) {
    self.connectionStatus |= HomeViewPresenterStatusMEWconnectConnection;
  } else {
    self.connectionStatus &= ~HomeViewPresenterStatusMEWconnectConnection;
  }
  [self _refreshViewStatusAnimated:YES];
  if (!connected) {
    [self.transactionModuleInput closeWithCompletion:nil];
  }
}

- (void) tokensDidStartUpdating {
  _tokensRefreshing = YES;
  [self.view startAnimatingTokensRefreshing];
}

- (void) tokensDidEndUpdating {
  _tokensRefreshing = NO;
  [self.view stopAnimatingTokensRefreshing];
}

- (void) networkDidChangedWithoutAccount {
  [self.router unwindToStart];
}

- (void) networkDidChangedWithAccount {
  [self configureAfterChangingNetwork];
}

- (void) internetConnectionIsReachable {
  self.connectionStatus |= HomeViewPresenterStatusInternetConnection;
}

- (void) internetConnectionIsUnreachable {
  self.connectionStatus &= ~HomeViewPresenterStatusInternetConnection;
}

#pragma mark - ConfirmationStoryModuleOutput

- (void) transactionDidSigned {
  [self.transactionModuleInput closeWithCompletion:nil];
}

- (void) transactionDidRejected {
  [self.transactionModuleInput closeWithCompletion:nil];
}

#pragma mark - Private

- (void) _refreshViewStatusAnimated:(BOOL)animated {
  [self.view updateStatusWithInternetConnection:(self.connectionStatus & HomeViewPresenterStatusInternetConnection) == HomeViewPresenterStatusInternetConnection
                           mewConnectConnection:(self.connectionStatus & HomeViewPresenterStatusMEWconnectConnection) == HomeViewPresenterStatusMEWconnectConnection
                                       animated:animated];
}

@end
