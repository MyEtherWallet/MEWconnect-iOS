//
//  ConfirmationNavigationRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ConfirmationNavigationRouter.h"

@implementation ConfirmationNavigationRouter

#pragma mark - ConfirmationNavigationRouterInput

- (void) closeWithCompletion:(ModuleCloseCompletionBlock)completion {
  [self.transitionHandler closeModulesUntil:self.transitionHandler.parentTransitionHandler animated:YES completion:completion];
}

@end
