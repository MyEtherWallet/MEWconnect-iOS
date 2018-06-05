//
//  ConfirmedTransactionRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurry;

#import "ConfirmedTransactionRouter.h"

static NSString *const kConfirmedTransactionToHomeUnwindSegueIdentifier = @"ConfirmedTransactionToHomeUnwindSegueIdentifier";

@implementation ConfirmedTransactionRouter

#pragma mark - ConfirmedTransactionRouterInput

- (void)close {
  [[self.transitionHandler openModuleUsingSegue:kConfirmedTransactionToHomeUnwindSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerViperModuleInput> moduleInput) {
    return nil;
  }];
}

@end
