//
//  MessageSignerRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "MessageSignerRouter.h"

@implementation MessageSignerRouter

#pragma mark - MessageSignerRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

@end
