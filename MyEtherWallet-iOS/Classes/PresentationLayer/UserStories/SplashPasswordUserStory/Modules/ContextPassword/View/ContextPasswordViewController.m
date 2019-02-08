//
//  ContextPasswordViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "ContextPasswordViewController.h"

#import "ContextPasswordViewOutput.h"

#import "UIView+LockFrame.h"
#import "FindFirstResponderProtocol.h"

#import "PasswordTextField.h"

static CGFloat const kContextPasswordShakeAnimationDistance = 10.0;
static CFTimeInterval const kContextPasswordShakeAnimationDuration = 0.05;
static float const kContextPasswordShakeAnimationRepeatCount = 3.0;

@interface ContextPasswordViewController () <UITextFieldDelegate, FindFirstResponderProtocol>
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet PasswordTextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIView *accessoryView;
@property (nonatomic) BOOL dismissing;
@property (nonatomic) BOOL skipResigning;
@end

@implementation ContextPasswordViewController

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
  @weakify(self);
  dispatch_async(dispatch_get_main_queue(), ^{
    @strongify(self);
    self.skipResigning = YES;
    [self.passwordTextField becomeFirstResponder];
  });
}

- (BOOL)canBecomeFirstResponder {
  return !_dismissing;
}

- (BOOL)resignFirstResponder {
  if (!_skipResigning) {
    [self.output resignAction];
  }
  _skipResigning = NO;
  return YES;
}

- (UIView *)inputAccessoryView {
  return self.accessoryView;
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (@available(iOS 11.0, *)) {
  } else {
    [self.passwordTextField becomeFirstResponder];
  }
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

- (void) lockPasswordField {
  [self.passwordTextField setText:nil];
  self.passwordTextField.inputEnabled = NO;
}

- (void) unlockPasswordField {
  self.passwordTextField.inputEnabled = YES;
  [self.passwordTextField becomeFirstResponder];
}

- (void) updateLockWithTimeInterval:(NSTimeInterval)unlockIn {
  NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
  [formatter setUnitsStyle:NSDateComponentsFormatterUnitsStylePositional];
  [formatter setAllowedUnits:NSCalendarUnitMinute|NSCalendarUnitSecond];
  [formatter setZeroFormattingBehavior:NSDateComponentsFormatterZeroFormattingBehaviorPad];
  NSString *unlockInText = [formatter stringFromTimeInterval:unlockIn];
  [self.passwordTextField setRightViewText:unlockInText];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(PasswordTextField *)textField shouldChangeCharactersInRange:(__unused NSRange)range replacementString:(__unused NSString *)string {
  return textField.inputEnabled;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.output doneActionWithPassword:textField.text];
  return NO;
}

#pragma mark - IBActions

- (IBAction) cancelAction:(__unused UIButton *)sender {
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

#pragma mark - FindFirstResponderProtocol

- (UIResponder *) providedFirstResponder {
  return self;
}

@end
