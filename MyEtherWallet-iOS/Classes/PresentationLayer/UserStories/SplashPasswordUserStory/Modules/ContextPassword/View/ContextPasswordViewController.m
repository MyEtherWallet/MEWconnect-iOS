//
//  ContextPasswordViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "ContextPasswordViewController.h"

#import "ContextPasswordViewOutput.h"

#import "UIView+LockFrame.h"

static CGFloat const kContextPasswordShakeAnimationDistance = 10.0;
static CFTimeInterval const kContextPasswordShakeAnimationDuration = 0.05;
static float const kContextPasswordShakeAnimationRepeatCount = 3.0;

@interface ContextPasswordViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIView *accessoryView;
@end

@implementation ContextPasswordViewController {
  BOOL _dismissing;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.passwordTextField.inputAccessoryView = self.accessoryView;
  
  //To show inputAccessoryView
  [self becomeFirstResponder];
  
  //To switch firstResponder to passwordTextField
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.passwordTextField becomeFirstResponder];
  });
}

- (BOOL)canBecomeFirstResponder {
  return !_dismissing;
}

- (UIView *)inputAccessoryView {
  return self.accessoryView;
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.view.lockFrame = YES;
}

- (void) viewLayoutMarginsDidChange {
  [super viewLayoutMarginsDidChange];
  [self _updatePrefferedContentSize];
}

#pragma mark - ContextPasswordViewInput

- (void) setupInitialStateWithTitle:(NSString *)title {
  self.titleLabel.text = title;
  [self _updatePrefferedContentSize];
}

- (void) shakeInput {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
  animation.duration = kContextPasswordShakeAnimationDuration;
  animation.repeatCount = kContextPasswordShakeAnimationRepeatCount;
  animation.autoreverses = YES;
  animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.passwordTextField.center.x - kContextPasswordShakeAnimationDistance, self.passwordTextField.center.y)];
  animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.passwordTextField.center.x + kContextPasswordShakeAnimationDistance, self.passwordTextField.center.y)];
  [self.passwordTextField.layer addAnimation:animation forKey:@"position"];
}

- (void) prepareForDismiss {
  _dismissing = YES;
  [self.passwordTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.output doneActionWithPassword:textField.text];
  return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
  
}

#pragma mark - IBActions

- (IBAction) cancelAction:(UIButton *)sender {
  [self.output cancelAction];
}

#pragma mark - Override

- (void) setCustomTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)customTransitioningDelegate {
  _customTransitioningDelegate = customTransitioningDelegate;
  self.transitioningDelegate = customTransitioningDelegate;
}

#pragma mark - Private

- (void) _updatePrefferedContentSize {
  CGRect bounds = self.presentingViewController.view.window.bounds;
  CGSize size = bounds.size;
  if (!CGSizeEqualToSize(self.preferredContentSize, size)) {
    self.preferredContentSize = size;
  }
}

@end
