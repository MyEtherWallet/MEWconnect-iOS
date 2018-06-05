//
//  HomeRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "HomeRouter.h"

#import "MessageSignerModuleInput.h"
#import "TransactionModuleInput.h"
#import "BackupInfoModuleInput.h"

static NSString *const kHomeToScannerSegueIdentifier        = @"HomeToScannerSegueIdentifier";
static NSString *const kHomeToMessageSignerSegueIdentifier  = @"HomeToMessageSignerSegueIdentifier";
static NSString *const kHomeToTransactionSegueIdentifier    = @"HomeToTransactionSegueIdentifier";
static NSString *const kHomeToBackupInfoSegueIdentifier     = @"HomeToBackupInfoSegueIdentifier";

@implementation HomeRouter

#pragma mark - HomeRouterInput

- (void) openScanner {
  [[self.transitionHandler openModuleUsingSegue:kHomeToScannerSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerViperModuleInput> moduleInput) {
    return nil;
  }];
}

- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command {
  [[self.transitionHandler openModuleUsingSegue:kHomeToMessageSignerSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<MessageSignerModuleInput> moduleInput) {
    [moduleInput configureModuleWithMessage:command];
    return nil;
  }];
}

- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command {
  [[self.transitionHandler openModuleUsingSegue:kHomeToTransactionSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<TransactionModuleInput> moduleInput) {
    [moduleInput configureModuleWithMessage:command];
    return nil;
  }];
}

- (void) openBackup {
  [[self.transitionHandler openModuleUsingSegue:kHomeToBackupInfoSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BackupInfoModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

@end
