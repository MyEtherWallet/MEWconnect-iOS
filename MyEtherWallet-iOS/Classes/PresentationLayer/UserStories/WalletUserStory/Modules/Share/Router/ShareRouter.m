//
//  ShareRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ShareRouter.h"

@implementation ShareRouter

#pragma mark - ShareRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

@end
