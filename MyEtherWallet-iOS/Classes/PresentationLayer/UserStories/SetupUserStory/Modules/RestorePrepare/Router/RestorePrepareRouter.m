//
//  RestorePrepareRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import ViperMcFlurryX;

#import "RestorePrepareRouter.h"

#import "RestoreWalletModuleInput.h"

static NSString *const kRestorePrepareToRestoreWalletSegueIdentifier = @"RestorePrepareToRestoreWalletSegueIdentifier";

@implementation RestorePrepareRouter

#pragma mark - RestorePrepareRouterInput

- (void) openRestoreWalletWhileForgotPassword:(BOOL)forgotPassword {
  [[self.transitionHandler openModuleUsingSegue:kRestorePrepareToRestoreWalletSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RestoreWalletModuleInput> moduleInput) {
    [moduleInput configureModuleWhileForgotPassword:forgotPassword];
    return nil;
  }];
}

@end
