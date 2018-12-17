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

#import "MEWConnectCommand.h"

#import "ConfirmationNavigationModuleInput.h"
#import "ConfirmationStoryModuleOutput.h"
#import "ContextPasswordModuleOutput.h"
#import "RestoreSeedModuleOutput.h"

typedef NS_OPTIONS(short, HomeViewPresenterStatus) {
  HomeViewPresenterStatusUnknown              =   0 << 0,
  HomeViewPresenterStatusInternetConnection   =   1 << 0,
  HomeViewPresenterStatusMEWconnectConnection =   1 << 1,
};

@interface HomePresenter () <ConfirmationStoryModuleOutput, ContextPasswordModuleOutput, RestoreSeedModuleOutput>
@property (nonatomic, weak) id <ConfirmationNavigationModuleInput> signModuleInput;
@property (nonatomic) HomeViewPresenterStatus connectionStatus;
@end

@implementation HomePresenter {
  BOOL _viewVisible;
  BOOL _balancesRefreshing;
  BOOL _transactionDidSigned;
}

#pragma mark - HomeModuleInput

- (void) configureModule {
  [self.interactor refreshMasterToken];
  [self.interactor configurate];
  MasterTokenPlainObject *masterToken = [self.interactor obtainMasterToken];
  [self.view updateWithMasterToken:masterToken];
}

- (void) configureBackupStatus {
  [self.interactor refreshMasterToken];
  MasterTokenPlainObject *masterToken = [self.interactor obtainMasterToken];
  [self.view updateWithMasterToken:masterToken];
}

- (void) configureAfterChangingNetwork {
  [self.interactor refreshMasterToken];
  MasterTokenPlainObject *masterToken = [self.interactor obtainMasterToken];
  [self.view updateWithMasterToken:masterToken];
  
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
  MasterTokenPlainObject *masterToken = [self.interactor obtainMasterToken];
  [self.view updateWithMasterToken:masterToken];
  
  [self _refreshViewStatusAnimated:NO];
  if (_balancesRefreshing) {
    [self.view startAnimatingRefreshing];
  }
}

- (void) didTriggerViewWillAppear {
  _viewVisible = YES;
  [self _refreshViewStatusAnimated:NO];
  if (_transactionDidSigned) {
    [self.interactor requestRaterIfNeeded];
    _transactionDidSigned = NO;
  }
}

- (void) didTriggerViewDidDisappear {
  _viewVisible = NO;
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
  [self.router openInfo];
}

- (void) buyEtherAction {
  MasterTokenPlainObject *masterToken = [self.interactor obtainMasterToken];
  [self.router openBuyEtherWithMasterToken:masterToken];
}

- (void) refreshTokensAction {
  [self.interactor reloadData];
}

- (void) shareAction {
  MasterTokenPlainObject *masterToken = [self.interactor obtainMasterToken];
  [self.router openShareWithMasterToken:masterToken];
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

- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken {
  @weakify(self);
  [self _closePresentedSignModulesIfNeededWithCompletion:^{
    @strongify(self);
    self.signModuleInput = [self.router openMessageSignerWithMessage:command masterToken:masterToken confirmationDelegate:self];
  }];
}

- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken {
  @weakify(self);
  [self _closePresentedSignModulesIfNeededWithCompletion:^{
    @strongify(self);
    self.signModuleInput = [self.router openTransactionSignerWithMessage:command masterToken:masterToken confirmationDelegate:self];
  }];
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
  MasterTokenPlainObject *masterToken = [self.interactor obtainMasterToken];
  [self.view updateBalanceWithMasterToken:masterToken];
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
    [self.signModuleInput closeWithCompletion:nil];
  }
}

- (void) balancesDidStartUpdating {
  _balancesRefreshing = YES;
  [self.view startAnimatingRefreshing];
}

- (void) balancesDidEndUpdating {
  _balancesRefreshing = NO;
  [self.view stopAnimatingRefreshing];
}

- (void) networkDidChanged {
  [self configureAfterChangingNetwork];
}

- (void) internetConnectionIsReachable {
  self.connectionStatus |= HomeViewPresenterStatusInternetConnection;
  [self _refreshViewStatusAnimated:_viewVisible];
}

- (void) internetConnectionIsUnreachable {
  self.connectionStatus &= ~HomeViewPresenterStatusInternetConnection;
  [self _refreshViewStatusAnimated:_viewVisible];
}

- (void) passwordIsNeededWithAccount:(AccountPlainObject *)account {
  [self.router openContextPasswordWithOutput:self account:account];
}

- (void)seedIsNeededWithAccount:(AccountPlainObject *)account password:(NSString *)password {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.router openRestoreSeedWithAccount:account password:password moduleOutput:self];
  });
}

#pragma mark - ConfirmationStoryModuleOutput

- (void) transactionDidSigned {
  _transactionDidSigned = YES;
  [self.interactor transactionDidSigned];
  [self.signModuleInput closeWithCompletion:nil];
}

- (void) transactionDidRejected {
  [self.signModuleInput closeWithCompletion:nil];
}

#pragma mark - ContextPasswordModuleOutput

- (void) passwordDidEntered:(NSString *)password {
  [self.interactor generateMissedKeysWithPassword:password];
}

#pragma mark - RestoreSeedModuleOutput

- (void)mnemonicsDidRestoredWithPassword:(NSString *)password {
  [self.interactor generateMissedKeysWithPassword:password];
}

#pragma mark - Private

- (void) _refreshViewStatusAnimated:(BOOL)animated {
  [self.view updateStatusWithInternetConnection:(self.connectionStatus & HomeViewPresenterStatusInternetConnection) == HomeViewPresenterStatusInternetConnection
                           mewConnectConnection:(self.connectionStatus & HomeViewPresenterStatusMEWconnectConnection) == HomeViewPresenterStatusMEWconnectConnection
                                       animated:animated];
}

- (void) _closePresentedSignModulesIfNeededWithCompletion:(void(^)(void))completion {
  if (self.signModuleInput) {
    [self.signModuleInput closeWithCompletion:completion];
  } else {
    if (completion) {
      completion();
    }
  }
}

@end
