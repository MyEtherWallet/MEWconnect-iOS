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

- (NSTimeInterval)transitionDuration:(__unused id <UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

- (void) animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  UIView *containerView = [transitionContext containerView];
  UIView *presentedView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
  
  [presentedView setNeedsLayout];
  [presentedView layoutIfNeeded];
  UIView *presentedViewSnapshot = [presentedView snapshotViewAfterScreenUpdates:YES];
  presentedView.hidden = YES;
  [containerView addSubview:presentedViewSnapshot];
  CGRect frame = presentedView.bounds;
  frame.origin.y = presentedView.frame.origin.y;
  presentedViewSnapshot.frame = frame;
  
  presentedViewSnapshot.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(containerView.bounds));
  
  UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut;
  
  [UIView animateWithDuration:[self transitionDuration:transitionContext]
                        delay:0.0
                      options:options
                   animations:^{
                     presentedViewSnapshot.transform = CGAffineTransformIdentity;
                   } completion:^(__unused BOOL finished) {
                     presentedView.hidden = NO;
                     [presentedViewSnapshot removeFromSuperview];
                     [transitionContext completeTransition:YES];
                   }];
}

@end
