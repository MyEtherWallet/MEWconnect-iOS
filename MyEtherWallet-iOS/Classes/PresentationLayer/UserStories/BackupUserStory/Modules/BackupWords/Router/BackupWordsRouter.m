//
//  BackupWordsRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "BackupWordsRouter.h"

#import "BackupConfirmationModuleInput.h"

static NSString *const kBackupWordsToBackupConfirmationSegueIdentifier = @"BackupWordsToBackupConfirmationSegueIdentifier";

@implementation BackupWordsRouter

#pragma mark - BackupWordsRouterInput

- (void) openConfirmationWithMnemonics:(NSArray<NSString *> *)mnemonics {
  [[self.transitionHandler openModuleUsingSegue:kBackupWordsToBackupConfirmationSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BackupConfirmationModuleInput> moduleInput) {
    [moduleInput configureModuleWithMnemonics:mnemonics];
    return nil;
  }];
}

@end
