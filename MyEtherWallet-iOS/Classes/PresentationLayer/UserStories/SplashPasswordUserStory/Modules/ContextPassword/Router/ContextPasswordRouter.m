//
//  ContextPasswordRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ContextPasswordRouter.h"

@implementation ContextPasswordRouter

#pragma mark - ContextPasswordRouterInput

- (void) close:(BOOL)animated {
  [self.transitionHandler closeCurrentModule:animated];
}

@end
