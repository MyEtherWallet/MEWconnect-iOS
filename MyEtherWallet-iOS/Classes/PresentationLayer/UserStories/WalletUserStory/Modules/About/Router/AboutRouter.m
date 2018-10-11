//
//  AboutRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "AboutRouter.h"

@implementation AboutRouter

#pragma mark - AboutRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

@end
