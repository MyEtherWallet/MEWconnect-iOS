//
//  BackupWordsRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BackupWordsRouter.h"

#import "BackupConfirmationModuleInput.h"

static NSString *const kBackupWordsToBackupConfirmationSegueIdentifier = @"BackupWordsToBackupConfirmationSegueIdentifier";

@implementation BackupWordsRouter

#pragma mark - BackupWordsRouterInput

- (void) openConfirmationWithMnemonics:(NSArray<NSString *> *)mnemonics account:(AccountPlainObject *)account {
  [[self.transitionHandler openModuleUsingSegue:kBackupWordsToBackupConfirmationSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BackupConfirmationModuleInput> moduleInput) {
    [moduleInput configureModuleWithMnemonics:mnemonics account:account];
    return nil;
  }];
}

@end
