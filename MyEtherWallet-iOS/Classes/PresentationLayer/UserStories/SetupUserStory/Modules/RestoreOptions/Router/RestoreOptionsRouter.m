//
//  RestoreOptionsRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import ViperMcFlurryX;

#import "RestoreOptionsRouter.h"
#import "RestorePrepareModuleInput.h"

static NSString *const kRestoreOptionsToRestoreSafetySegueIdentifier = @"RestoreOptionsToRestoreSafetySegueIdentifier";
static NSString *const kRestoreOptionsToRestorePrepareSegueIdentifier = @"RestoreOptionsToRestorePrepareSegueIdentifier";

@implementation RestoreOptionsRouter

#pragma mark - RestoreOptionsRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) openRestoreSafery {
  [[self.transitionHandler openModuleUsingSegue:kRestoreOptionsToRestoreSafetySegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(__unused id<RamblerViperModuleInput> moduleInput) {
    return nil;
  }];
}

- (void) openPrepareWhileForgotPassword:(BOOL)forgotPassword {
  [[self.transitionHandler openModuleUsingSegue:kRestoreOptionsToRestorePrepareSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RestorePrepareModuleInput> moduleInput) {
    [moduleInput configureModuleWhileForgotPassword:forgotPassword];
    return nil;
  }];
}

@end
