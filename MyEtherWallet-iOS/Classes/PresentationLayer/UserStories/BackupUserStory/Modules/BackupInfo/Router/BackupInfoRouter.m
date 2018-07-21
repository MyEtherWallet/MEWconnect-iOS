//
//  BackupInfoRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BackupInfoRouter.h"

#import "BackupStartModuleInput.h"

static NSString *const kBackupInfoToBackupStartSegueIdentifier = @"BackupInfoToBackupStartSegueIdentifier";

@implementation BackupInfoRouter

#pragma mark - BackupInfoRouterInput

- (void) openBackupStartWithAccount:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kBackupInfoToBackupStartSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BackupStartModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account];
    return nil;
  }];
}

- (void)close {
  [self.transitionHandler closeCurrentModule:YES];
}

@end
