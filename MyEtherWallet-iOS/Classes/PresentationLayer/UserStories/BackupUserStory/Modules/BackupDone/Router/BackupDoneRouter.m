//
//  BackupDoneRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BackupDoneRouter.h"

#import "HomeModuleInput.h"

static NSString *const kBackupDoneToHomeUnwindSegueIdentifier = @"BackupDoneToHomeUnwindSegueIdentifier";

@implementation BackupDoneRouter

#pragma mark - BackupDoneRouterInput

- (void)unwindToHome {
  [[self.transitionHandler openModuleUsingSegue:kBackupDoneToHomeUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<HomeModuleInput> moduleInput) {
    [moduleInput configureBackupStatus];
    return nil;
  }];
}

@end
