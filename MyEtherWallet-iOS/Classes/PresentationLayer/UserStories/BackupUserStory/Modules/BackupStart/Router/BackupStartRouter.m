//
//  BackupStartRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "BackupStartRouter.h"

#import "BackupWordsModuleInput.h"

static NSString *const kBackupStartToBackupWordsSegueIdentifier = @"BackupStartToBackupWordsSegueIdentifier";

@implementation BackupStartRouter

#pragma mark - BackupStartRouterInput

- (void) openWords {
  [[self.transitionHandler openModuleUsingSegue:kBackupStartToBackupWordsSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BackupWordsModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

@end
