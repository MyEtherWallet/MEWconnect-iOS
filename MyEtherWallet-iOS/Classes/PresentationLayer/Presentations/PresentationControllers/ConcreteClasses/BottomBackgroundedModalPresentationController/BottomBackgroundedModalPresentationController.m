//
//  BottomBackgroundedModalPresentationController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BottomBackgroundedModalPresentationController.h"

#import "BlockchainNetworkService.h"
#import "Ponsomizer.h"

#import "NetworkPlainObject.h"
#import "MasterTokenPlainObject.h"

//#import "AccountPlainObject.h"

#import "UIImage+MEWBackground.h"
#import "UIView+LockFrame.h"

@interface BottomBackgroundedModalPresentationController ()
@property (nonatomic, strong, readonly) UIImageView *mewBackground;
@property (nonatomic, strong, readonly) UIView *presentingSnapshot;
@property (nonatomic, strong, readonly) UIView *presentedWrapper;
@end

@implementation BottomBackgroundedModalPresentationController
@synthesize mewBackground = _mewBackground;
@synthesize presentingSnapshot = _presentingSnapshot;

- (UIImageView *) mewBackground {
  if (!_mewBackground) {
    _mewBackground = [[UIImageView alloc] init];
    _mewBackground.translatesAutoresizingMaskIntoConstraints = NO;
    
    NetworkModelObject *networkModelObject = [self.networkService obtainActiveNetwork];
    
    NSArray *ignoringProperties = @[NSStringFromSelector(@selector(fromAccount)),
                                    NSStringFromSelector(@selector(tokens)),
                                    NSStringFromSelector(@selector(fromNetwork)),
                                    NSStringFromSelector(@selector(price)),
                                    NSStringFromSelector(@selector(purchaseHistory))];
    NetworkPlainObject *network = [self.ponsomizer convertObject:networkModelObject ignoringProperties:ignoringProperties];
    MasterTokenPlainObject *masterToken = network.master;
    
    _mewBackground.image = [UIImage cachedBackgroundWithSeed:masterToken.address
                                                        size:[UIImage fullSize]
                                                        logo:NO];
  }
  return _mewBackground;
}

- (UIView *) presentedView {
  if (!_presentedWrapper) {
    _presentedWrapper = [[UIView alloc] initWithFrame:[super presentedView].frame];
    _presentedWrapper.autoresizingMask = [super presentedView].autoresizingMask;
    _presentedWrapper.lockFrame = YES;
  }
  return _presentedWrapper;
}

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

- (void) presentationTransitionWillBegin {
  [self.presentedView addSubview:[super presentedView]];
  [self.presentingSnapshot addSubview:self.mewBackground];
  [self.presentingSnapshot.topAnchor constraintEqualToAnchor:self.mewBackground.topAnchor].active = YES;
  [self.presentingSnapshot.leftAnchor constraintEqualToAnchor:self.mewBackground.leftAnchor].active = YES;
  [self.presentingSnapshot.rightAnchor constraintEqualToAnchor:self.mewBackground.rightAnchor].active = YES;
  
  [self.containerView addSubview:self.presentingSnapshot];
  [self.containerView.topAnchor constraintEqualToAnchor:self.presentingSnapshot.topAnchor].active = YES;
  [self.containerView.leftAnchor constraintEqualToAnchor:self.presentingSnapshot.leftAnchor].active = YES;
  [self.containerView.rightAnchor constraintEqualToAnchor:self.presentingSnapshot.rightAnchor].active = YES;
  [self.containerView.bottomAnchor constraintEqualToAnchor:self.presentingSnapshot.bottomAnchor].active = YES;
  
  [self.containerView addSubview:self.presentedView];
  
  if (self.presentedViewController.transitionCoordinator.animated) {
    self.mewBackground.alpha = 0.0;
    [self.presentedView snapshotViewAfterScreenUpdates:YES];
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
        self.mewBackground.alpha = 1.0;
    } completion:nil];
  }
}

- (void) presentationTransitionDidEnd:(BOOL)completed {
  if (!completed) {
    [self.presentingSnapshot removeFromSuperview];
  }
}

- (void) dismissalTransitionWillBegin {
  [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(__unused id<UIViewControllerTransitionCoordinatorContext> context) {
    self.mewBackground.alpha = 0.0;
  } completion:nil];
}

- (void) dismissalTransitionDidEnd:(BOOL)completed {
  if (completed) {
    [self.mewBackground removeFromSuperview];
    [self.presentingSnapshot removeFromSuperview];
  }
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

