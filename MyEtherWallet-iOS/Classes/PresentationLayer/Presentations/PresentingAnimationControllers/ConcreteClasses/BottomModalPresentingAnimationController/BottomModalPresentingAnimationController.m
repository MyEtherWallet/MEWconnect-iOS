//
//  BottomModalPresentingAnimationController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BottomModalPresentingAnimationController.h"

@implementation BottomModalPresentingAnimationController

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  UIView *containerView = [transitionContext containerView];
  UIView *presentedView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
  
  presentedView.frame = containerView.bounds;
  [containerView addSubview:presentedView];
  
  CGAffineTransform transform = presentedView.transform;
  presentedView.transform = CGAffineTransformTranslate(transform, 0, CGRectGetHeight(containerView.bounds));
  
  UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut;
  
  [UIView animateWithDuration:[self transitionDuration:transitionContext]
                        delay:0.0
                      options:options
                   animations:^{
                     presentedView.transform = transform;
                   } completion:^(BOOL finished) {
                     [transitionContext completeTransition:YES];
                   }];
}

@end
