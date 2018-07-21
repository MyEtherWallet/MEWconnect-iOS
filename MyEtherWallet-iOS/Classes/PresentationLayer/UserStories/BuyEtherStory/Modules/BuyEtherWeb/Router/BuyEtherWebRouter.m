//
//  BuyEtherWebRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BuyEtherWebRouter.h"

@implementation BuyEtherWebRouter

#pragma mark - BuyEtherWebRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

@end
