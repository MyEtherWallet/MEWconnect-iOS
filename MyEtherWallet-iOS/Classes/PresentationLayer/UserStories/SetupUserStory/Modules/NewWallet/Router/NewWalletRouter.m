//
//  NewWalletRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "NewWalletRouter.h"

#import "StartModuleInput.h"
#import "HomeModuleInput.h"

static NSString *const kNewWalletToStartUnwindSegueIdentifier = @"NewWalletToStartUnwindSegueIdentifier";
static NSString *const kNewWalletToHomeUnwindSegueIdentifier  = @"NewWalletToHomeUnwindSegueIdentifier";

@implementation NewWalletRouter

#pragma mark - NewWalletRouterInput

- (void) unwindToWallet {
  [[self.transitionHandler openModuleUsingSegue:kNewWalletToHomeUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<HomeModuleInput> moduleInput) {
    [moduleInput configureModule];
    return nil;
  }];
}

- (void) unwindToStart {
  [[self.transitionHandler openModuleUsingSegue:kNewWalletToStartUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<StartModuleInput> moduleInput) {
    [moduleInput configurateForCreatedWallet];
    return nil;
  }];
}

@end
