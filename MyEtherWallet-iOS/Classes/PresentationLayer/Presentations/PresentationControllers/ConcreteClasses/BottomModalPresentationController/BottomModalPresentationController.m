//
//  BottomModalPresentationController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BottomModalPresentationController.h"

#import "UIView+LockFrame.h"

@interface BottomModalPresentationController ()
@property (nonatomic, strong) UIView *dimmingView;
@end

@implementation BottomModalPresentationController

- (UIView *)dimmingView {
  if (!_dimmingView) {
    _dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    _dimmingView.backgroundColor = [UIColor blackColor];
  }
  return _dimmingView;
}

- (void) presentationTransitionWillBegin {
  [super presentationTransitionWillBegin];
  
  if (self.dimmed) {
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0;
    [self.containerView addSubview:self.dimmingView];
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
      self.dimmingView.alpha = 0.4;
    } completion:nil];
  }
  
  if (self.presentedViewController.transitionCoordinator.animated) {
    [self.presentedView snapshotViewAfterScreenUpdates:YES];
  }
}

- (void) presentationTransitionDidEnd:(BOOL)completed {
  if (!completed) {
    if (self.dimmed) {
      [self.dimmingView removeFromSuperview];
    }
  } else {
    self.presentedView.lockFrame = YES;
  }
  [super presentationTransitionDidEnd:completed];
}

- (void) dismissalTransitionWillBegin {
  self.presentedView.lockFrame = NO;
  if (self.dimmed) {
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
      self.dimmingView.alpha = 0;
    } completion:nil];
  }
  [super dismissalTransitionWillBegin];
}

- (void) dismissalTransitionDidEnd:(BOOL)completed {
  if (!completed) {
    self.presentedView.lockFrame = YES;
  } else if (self.dimmed) {
    [self.dimmingView removeFromSuperview];
  }
  [super dismissalTransitionDidEnd:completed];
}

- (CGRect) frameOfPresentedViewInContainerView {
  CGSize size = self.presentedViewController.preferredContentSize;
  CGRect frame = CGRectMake(0.0, CGRectGetHeight(self.containerView.bounds) - size.height,
                            CGRectGetWidth(self.containerView.bounds), size.height);
  return frame;
}

- (void) containerViewWillLayoutSubviews {
  [super containerViewWillLayoutSubviews];
  CGRect frame = [self frameOfPresentedViewInContainerView];
  if (self.dimmed) {
    self.dimmingView.frame = self.containerView.bounds;
  }
  if (!CGRectEqualToRect([super presentedView].frame, frame) ||
      !CGSizeEqualToSize([super presentedView].layer.mask.frame.size, frame.size)) {
    [self _updateMaskWithFrame:frame];
  }
}

//cornerRadius for top
- (void) _updateMaskWithFrame:(CGRect)frame {
  CGRect bounds = frame;
  bounds.origin = CGPointZero;
  
  if (![super presentedView].layer.mask) {
    [super presentedView].layer.mask = [CAShapeLayer layer];
  }
  
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                 byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                       cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
  CAShapeLayer *maskLayer = (CAShapeLayer *)[super presentedView].layer.mask;
  maskLayer.frame = bounds;
  maskLayer.path = maskPath.CGPath;
  maskLayer.shouldRasterize = YES;
  maskLayer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
