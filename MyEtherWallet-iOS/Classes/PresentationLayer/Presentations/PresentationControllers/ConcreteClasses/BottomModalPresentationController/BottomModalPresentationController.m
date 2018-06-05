//
//  BottomModalPresentationController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BottomModalPresentationController.h"

@implementation BottomModalPresentationController

- (void)presentationTransitionWillBegin {
  [self _updateMask];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
}

- (void)dismissalTransitionWillBegin {
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
}

- (CGRect) frameOfPresentedViewInContainerView {
  CGSize size = self.presentedViewController.preferredContentSize;
  CGRect frame = CGRectMake(0.0, CGRectGetHeight(self.containerView.frame) - size.height,
                            CGRectGetWidth(self.containerView.bounds), size.height);
  return frame;
}

- (void)containerViewWillLayoutSubviews {
  [super containerViewWillLayoutSubviews];
  self.presentedView.frame = [self frameOfPresentedViewInContainerView];
  [self _updateMask];
}

//cornerRadius for top
- (void) _updateMask {
  UIView *presentedView = self.presentedViewController.view;
  CGRect bounds = [self frameOfPresentedViewInContainerView];
  bounds.origin = CGPointZero;
  
  if (!presentedView.layer.mask) {
    presentedView.layer.mask = [CAShapeLayer layer];
  }
  
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                 byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                       cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
  CAShapeLayer *maskLayer = (CAShapeLayer *)presentedView.layer.mask;
  maskLayer.frame = bounds;
  maskLayer.path = maskPath.CGPath;
  maskLayer.shouldRasterize = YES;
  maskLayer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
