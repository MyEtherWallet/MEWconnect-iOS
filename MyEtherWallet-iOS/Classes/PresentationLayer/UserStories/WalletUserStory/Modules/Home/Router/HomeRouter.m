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
#import "InfoModuleInput.h"

static NSString *const kHomeToScannerSegueIdentifier        = @"HomeToScannerSegueIdentifier";
static NSString *const kHomeToMessageSignerSegueIdentifier  = @"HomeToMessageSignerSegueIdentifier";
static NSString *const kHomeToTransactionSegueIdentifier    = @"HomeToTransactionSegueIdentifier";
static NSString *const kHomeToBackupInfoSegueIdentifier     = @"HomeToBackupInfoSegueIdentifier";
static NSString *const kHomeToInfoSegueIdentifier           = @"HomeToInfoSegueIdentifier";

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

- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command account:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kHomeToTransactionSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<TransactionModuleInput> moduleInput) {
    [moduleInput configureModuleWithMessage:command account:account];
    return nil;
  }];
}

- (void) openBackupWithAccount:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kHomeToBackupInfoSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BackupInfoModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account];
    return nil;
  }];
}

- (void) openInfoWithAccount:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kHomeToInfoSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<InfoModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account];
    return nil;
  }];
}

@end
