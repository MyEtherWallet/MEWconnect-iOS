//
//  BottomBackgroundedModalPresentationController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BottomBackgroundedModalPresentationController.h"

#import "MEWwallet.h"

#import "UIImage+MEWBackground.h"

@interface BottomBackgroundedModalPresentationController ()
@property (nonatomic, strong, readonly) UIImageView *mewBackground;
@end

@implementation BottomBackgroundedModalPresentationController
@synthesize mewBackground = _mewBackground;

- (UIImageView *) mewBackground {
  if (!_mewBackground) {
    _mewBackground = [[UIImageView alloc] init];
    _mewBackground.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *address = [self.walletService obtainPublicAddress];
    _mewBackground.image = [UIImage cachedBackgroundWithSeed:address
                                                        size:[UIImage fullSize]
                                                        logo:NO];
  }
  return _mewBackground;
}

- (void)presentationTransitionWillBegin {
  [self _updateMask];
  
  self.mewBackground.alpha = 0.0;
  [self.containerView addSubview:self.mewBackground];
  [self.containerView.topAnchor constraintEqualToAnchor:self.mewBackground.topAnchor].active = YES;
  [self.containerView.leftAnchor constraintEqualToAnchor:self.mewBackground.leftAnchor].active = YES;
  [self.containerView.rightAnchor constraintEqualToAnchor:self.mewBackground.rightAnchor].active = YES;
  
  [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    self.mewBackground.alpha = 1.0;
  } completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
  if (!completed) {
    [self.mewBackground removeFromSuperview];
  }
}

- (void)dismissalTransitionWillBegin {
  [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    self.mewBackground.alpha = 0.0;
  } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
  if (completed) {
    [self.mewBackground removeFromSuperview];
  }
}

- (CGRect) frameOfPresentedViewInContainerView {
  CGSize size = self.presentedViewController.preferredContentSize;
  CGRect frame = CGRectMake(0.0, CGRectGetHeight(self.containerView.bounds) - size.height,
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
