//
//  BackupConfirmationRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BackupConfirmationRouter.h"

#import "BackupDoneModuleInput.h"

static NSString *const kBackupConfirmationToBackupDoneSegueIdentifier = @"BackupConfirmationToBackupDoneSegueIdentifier";

@implementation BackupConfirmationRouter

#pragma mark - BackupConfirmationRouterInput

- (void) openDone {
  [[self.transitionHandler openModuleUsingSegue:kBackupConfirmationToBackupDoneSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BackupDoneModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

@end
