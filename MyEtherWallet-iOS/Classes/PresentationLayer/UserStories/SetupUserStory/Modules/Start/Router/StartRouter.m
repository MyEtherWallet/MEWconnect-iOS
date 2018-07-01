//
//  StartRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "StartRouter.h"

#import "HomeModuleInput.h"
#import "RestoreWalletModuleInput.h"

static NSString *const kStartToPasswordSegueIdentifier        = @"StartToPasswordSegueIdentifier";
static NSString *const kStartToHomeAnimatedSegueIdentifier    = @"StartToHomeAnimatedSegueIdentifier";
static NSString *const kStartToHomeSegueIdentifier            = @"StartToHomeSegueIdentifier";
static NSString *const kStartToRestoreWalletSegueIdentifier   = @"StartToRestoreWalletSegueIdentifier";

@implementation StartRouter

#pragma mark - StartRouterInput

- (void) openCreateNewWallet {
  [[self.transitionHandler openModuleUsingSegue:kStartToPasswordSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerViperModuleInput> moduleInput) {
    return nil;
  }];
}

- (void) openWalletAnimated:(BOOL)animated {
  NSString *segueIdentifier = animated ? kStartToHomeAnimatedSegueIdentifier : kStartToHomeSegueIdentifier;
  [[self.transitionHandler openModuleUsingSegue:segueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<HomeModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

- (void) openRestoreWallet {
  [[self.transitionHandler openModuleUsingSegue:kStartToRestoreWalletSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RestoreWalletModuleInput> moduleInput) {
    [moduleInput configureModuleWhileForgotPassword:NO];
    return nil;
  }];
}

@end
