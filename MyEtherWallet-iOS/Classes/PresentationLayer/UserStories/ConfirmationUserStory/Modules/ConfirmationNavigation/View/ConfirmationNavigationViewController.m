//
//  ConfirmationNavigationViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmationNavigationViewController.h"

#import "ConfirmationNavigationViewOutput.h"

#import "ApplicationConstants.h"

#import "UIView+LockFrame.h"

@implementation ConfirmationNavigationViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];
  self.modalPresentationCapturesStatusBarAppearance = YES;
	[self.output didTriggerViewReadyEvent];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.view.lockFrame = YES;
}

- (void)viewLayoutMarginsDidChange {
  [super viewLayoutMarginsDidChange];
  [self _updatePrefferedContentSize];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - Override

- (void)setCustomTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)customTransitioningDelegate {
  _customTransitioningDelegate = customTransitioningDelegate;
  self.transitioningDelegate = customTransitioningDelegate;
}

#pragma mark - ConfirmationNavigationViewInput

- (void) setupInitialState {
  [self _updatePrefferedContentSize];
}

#pragma mark - Private

- (void) _updatePrefferedContentSize {
  CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
  CGRect bounds = self.presentingViewController.view.window.bounds;
  CGSize size = bounds.size;
  size.height -= CGRectGetHeight(statusBarFrame);
  size.height -= kCustomRepresentationTopSmallOffset;
  if (!CGSizeEqualToSize(self.preferredContentSize, size)) {
    self.preferredContentSize = size;
  }
}

@end
