//
//  RestoreSeedRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import ViperMcFlurryX;

#import "RestoreSeedRouter.h"

@implementation RestoreSeedRouter

#pragma mark - RestoreSeedRouterInput

- (void)close {
  [self.transitionHandler closeCurrentModule:YES];
}

@end
