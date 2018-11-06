//
//  BuyEtherAmountRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BuyEtherWebModuleInput.h"
#import "BuyEtherHistoryModuleInput.h"

#import "BuyEtherAmountRouter.h"

static NSString *const kBuyEtherAmountToBuyEtherWebSegueIdentifier      = @"BuyEtherAmountToBuyEtherWebSegueIdentifier";
static NSString *const kBuyEtherAmountToBuyEtherHistorySegueIdentifier  = @"BuyEtherAmountToBuyEtherHistorySegueIdentifier";

@implementation BuyEtherAmountRouter

#pragma mark - BuyEtherAmountRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

- (void) openBuyEtherWebWithOrder:(SimplexOrder *)order masterToken:(MasterTokenPlainObject *)masterToken {
  [[self.transitionHandler openModuleUsingSegue:kBuyEtherAmountToBuyEtherWebSegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BuyEtherWebModuleInput> moduleInput) {
    [moduleInput configureModuleWithOrder:order forMasterToken:masterToken];
    return nil;
  }];
}

- (void) openBuyEtherHistoryForMasterToken:(MasterTokenPlainObject *)masterToken {
  [[self.transitionHandler openModuleUsingSegue:kBuyEtherAmountToBuyEtherHistorySegueIdentifier] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<BuyEtherHistoryModuleInput> moduleInput) {
    [moduleInput configureModuleWithMasterToken:masterToken];
    return nil;
  }];
}

@end
