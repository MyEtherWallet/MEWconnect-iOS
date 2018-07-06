//
//  SplashPasswordViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordViewController.h"

#import "SplashPasswordViewOutput.h"

#import "ApplicationConstants.h"

static CGFloat const kSplashPasswordShakeAnimationDistance = 10.0;
static CFTimeInterval const kSplashPasswordShakeAnimationDuration = 0.05;
static float const kSplashPasswordShakeAnimationRepeatCount = 3.0;

@interface SplashPasswordViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@end

@implementation SplashPasswordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];
  self.modalPresentationCapturesStatusBarAppearance = YES;
	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.passwordTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
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

#pragma mark - SplashPasswordViewInput

- (void) setupInitialState {
  [self _updatePrefferedContentSize];
}

- (void) shakeInput {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.duration = kSplashPasswordShakeAnimationDuration;
  animation.repeatCount = kSplashPasswordShakeAnimationRepeatCount;
  animation.autoreverses = YES;
  animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.passwordTextField.center.x - kSplashPasswordShakeAnimationDistance, self.passwordTextField.center.y)];
  animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.passwordTextField.center.x + kSplashPasswordShakeAnimationDistance, self.passwordTextField.center.y)];
  [self.passwordTextField.layer addAnimation:animation forKey:@"position"];
}

#pragma mark - IBActions

- (IBAction) passwordDidChanged:(UITextField *)sender {
  
}

- (IBAction) forgotPasswordAction:(UIButton *)sender {
  [self.output forgotPasswordAction];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.output doneActionWithPassword:textField.text];
  return NO;
}

#pragma mark - Private

- (void) _updatePrefferedContentSize {
  CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
  CGRect bounds = self.view.window.bounds;
  CGSize size = bounds.size;
  size.height -= CGRectGetHeight(statusBarFrame);
  size.height -= kCustomRepresentationTopBigOffset;
  if (!CGSizeEqualToSize(self.preferredContentSize, size)) {
    self.preferredContentSize = size;
  }
}

@end
