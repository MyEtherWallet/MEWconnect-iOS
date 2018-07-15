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
@property (nonatomic, strong, readonly) UIView *presentingSnapshot;
@property (nonatomic, strong, readonly) UIView *presentedWrapper;
@end

@implementation BottomModalPresentationController
@synthesize presentingSnapshot = _presentingSnapshot;

- (UIView *) presentingSnapshot {
  if (!_presentingSnapshot) {
    UIView *viewForSnapshot = self.presentingViewController.view;
    if (self.presentingViewController.presentationController.containerView != nil) {
      viewForSnapshot = self.presentingViewController.presentationController.containerView;
    }
    _presentingSnapshot = [viewForSnapshot snapshotViewAfterScreenUpdates:NO];
    _presentingSnapshot.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _presentingSnapshot;
}

- (UIView *) presentedView {
  if (!_presentedWrapper) {
    _presentedWrapper = [[UIView alloc] initWithFrame:[super presentedView].frame];
    _presentedWrapper.autoresizingMask = [super presentedView].autoresizingMask;
    _presentedWrapper.lockFrame = YES;
  }
  return _presentedWrapper;
}

- (void)presentationTransitionWillBegin {
  [self.presentedView addSubview:[super presentedView]];
  [self.containerView addSubview:self.presentingSnapshot];
  [self.containerView.topAnchor constraintEqualToAnchor:self.presentingSnapshot.topAnchor].active = YES;
  [self.containerView.leftAnchor constraintEqualToAnchor:self.presentingSnapshot.leftAnchor].active = YES;
  [self.containerView.rightAnchor constraintEqualToAnchor:self.presentingSnapshot.rightAnchor].active = YES;
  [self.containerView.bottomAnchor constraintEqualToAnchor:self.presentingSnapshot.bottomAnchor].active = YES;
  
  [self.containerView addSubview:self.presentedView];
  
  if (self.presentedViewController.transitionCoordinator.animated) {
    [self.presentedView snapshotViewAfterScreenUpdates:YES];
  }
}

- (void) presentationTransitionDidEnd:(BOOL)completed {
  if (!completed) {
    [self.presentingSnapshot removeFromSuperview];
  }
}

- (void) dismissalTransitionWillBegin {
}

- (void) dismissalTransitionDidEnd:(BOOL)completed {
  if (completed) {
    [self.presentingSnapshot removeFromSuperview];
  }
}

- (CGRect) frameOfPresentedViewInContainerView {
  CGSize size = self.presentedViewController.preferredContentSize;
  CGRect frame = CGRectMake(0.0, CGRectGetHeight(self.containerView.frame) - size.height,
                            CGRectGetWidth(self.containerView.bounds), size.height);
  return frame;
}

- (void) containerViewWillLayoutSubviews {
  [super containerViewWillLayoutSubviews];
  CGRect frame = [self frameOfPresentedViewInContainerView];
  if (!CGRectEqualToRect([super presentedView].frame, frame)) {
    [super presentedView].frame = frame;
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
