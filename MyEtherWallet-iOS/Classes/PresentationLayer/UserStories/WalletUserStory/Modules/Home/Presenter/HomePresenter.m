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

- (void) configureModuleWithAddress:(NSString *)address {
  [self.interactor configurateWithAddress:address];
}

- (void)configuraBackupStatus {
  BOOL backedUp = [self.interactor obtainBackupStatus];
  [self.view updateBackupStatus:backedUp];
}

#pragma mark - HomeViewOutput

- (void) didTriggerViewReadyEvent {
  NSUInteger count = [self.interactor obtainNumberOfTokens];
	[self.view setupInitialStateWithNumberOfTokens:count];
  NSString *address = [self.interactor obtainAddress];
  [self.view updateWithAddress:address];
  BOOL backedUp = [self.interactor obtainBackupStatus];
  [self.view updateBackupStatus:backedUp];
  BOOL connected = [self.interactor isConnected];
  [self.view updateWithConnectionStatus:connected animated:NO];
  TokenPlainObject *ethereum = [self.interactor obtainEthereum];
  [self.view updateEthereumBalance:ethereum];
  
  //TODO: Remove in future
  NSInteger chainID = [[NSUserDefaults standardUserDefaults] integerForKey:@"chainID"];
  if (chainID == 3) {
    [self.view updateTitle:NSLocalizedString(@"MEW Connect: Ropsten", @"Home screen. Title")];
  } else {
    [self.view updateTitle:NSLocalizedString(@"MEW Connect", @"Home screen. Title")];
  }
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
  [self.router openBackup];
}

- (void) searchTermDidChanged:(NSString *)searchTerm {
  [self.interactor searchTokensWithTerm:searchTerm];
}

- (void)mainnetSelectedAction {
  [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"chainID"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [self reloadData];
  [self.view updateTitle:NSLocalizedString(@"MEW Connect", @"Home screen. Title")];
}

- (void)ropstenSelectedAction {
  [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"chainID"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [self reloadData];
  [self.view updateTitle:NSLocalizedString(@"MEW Connect: Ropsten", @"Home screen. Title")];
}

- (void) reloadData {
  [self.interactor reloadData];
}

#pragma mark - HomeInteractorOutput

- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command {
  [self.router openMessageSignerWithMessage:command];
}

- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command {
  [self.router openTransactionSignerWithMessage:command];
}

- (void) didUpdateTokens {
  NSUInteger count = [self.interactor obtainNumberOfTokens];
  [self.view updateWithTokensCount:count];
}

- (void) didUpdateEthereumBalance {
  TokenPlainObject *ethereum = [self.interactor obtainEthereum];
  [self.view updateEthereumBalance:ethereum];
}

- (void) mewConnectionStatusChanged {
  BOOL connected = [self.interactor isConnected];
  [self.view updateWithConnectionStatus:connected animated:YES];
}

@end
