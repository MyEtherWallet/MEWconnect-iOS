//
//  BackupStartRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BackupStartRouter.h"

#import "SplashPasswordModuleInput.h"
#import "SplashPasswordModuleOutput.h"
#import "BackupWordsModuleInput.h"

static NSString *const kBackupStartToSplashPasswordSegueIdentifier = @"BackupStartToSplashPasswordSegueIdentifier";
static NSString *const kBackupStartToBackupWordsSegueIdentifier = @"BackupStartToBackupWordsSegueIdentifier";

@implementation BackupStartRouter

#pragma mark - BackupStartRouterInput

- (void) openSplashPasswordWithOutput:(id <SplashPasswordModuleOutput>)output account:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kBackupStartToSplashPasswordSegueIdentifier] thenChainUsingBlock:^id<SplashPasswordModuleOutput>(id<SplashPasswordModuleInput> moduleInput) {
    [moduleInput configureModuleWithAccount:account autoControl:YES];
    return output;
  }];
}

- (void) openWordsWithMnemonics:(NSArray<NSString *> *)mnemonics account:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kBackupStartToBackupWordsSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BackupWordsModuleInput> moduleInput) {
    [moduleInput configureModuleWithMnemonics:mnemonics account:account];
    return nil;
  }];
}

@end
