//
//  BackupDoneRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BackupDoneRouter.h"

#import "InfoViewController.h"

#import "HomeModuleInput.h"
#import "InfoModuleInput.h"

static NSString *const kBackupDoneToHomeUnwindSegueIdentifier = @"BackupDoneToHomeUnwindSegueIdentifier";
static NSString *const kBackupDoneToInfoUnwindSegueIdentifier = @"BackupDoneToInfoUnwindSegueIdentifier";

@implementation BackupDoneRouter

#pragma mark - BackupDoneRouterInput

- (void)unwindToHome {
  UIViewController *viewController = (UIViewController *)self.transitionHandler;
  if ([viewController.presentingViewController isKindOfClass:[InfoViewController class]]) {
    [[self.transitionHandler openModuleUsingSegue:kBackupDoneToInfoUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<InfoModuleInput> moduleInput) {
      [moduleInput configureAccountBackupStatus];
      return nil;
    }];
  } else {
    [[self.transitionHandler openModuleUsingSegue:kBackupDoneToHomeUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<HomeModuleInput> moduleInput) {
      [moduleInput configureBackupStatus];
      return nil;
    }];
  }
}

@end
