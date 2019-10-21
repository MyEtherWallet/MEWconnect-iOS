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

#import "UIImage+Color.h"

static CGFloat const kContextPasswordShakeAnimationDistance = 10.0;
static CFTimeInterval const kContextPasswordShakeAnimationDuration = 0.05;
static float const kContextPasswordShakeAnimationRepeatCount = 3.0;

static CGFloat const ContextPasswordViewCornerRadius  = 12.0;
static CGFloat const ContextPasswordDefaultBottomInset = 25.0;

@interface ContextPasswordViewController () <UITextFieldDelegate, FindFirstResponderProtocol>
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet PasswordTextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation ContextPasswordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

  dispatch_async(dispatch_get_main_queue(), ^{
    [self.passwordTextField becomeFirstResponder];
  });
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewLayoutMarginsDidChange {
  [super viewLayoutMarginsDidChange];
  [self _updatePrefferedContentSize];
}

#pragma mark - ContextPasswordViewInput

- (void) setupInitialStateWithTitle:(NSString *)title {
  self.titleLabel.text = title;
  
  CGFloat size = ContextPasswordViewCornerRadius * 2.0 + 10.0;
  CGFloat halfSize = size / 2.0;
  UIImage *backgroundImage = [[UIImage imageWithColor:[UIColor whiteColor]
                                                 size:CGSizeMake(size, size)
                                         cornerRadius:ContextPasswordViewCornerRadius
                                              corners:UIRectCornerTopLeft|UIRectCornerTopRight]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(halfSize, halfSize, halfSize, halfSize)];
  self.backgroundImageView.image = backgroundImage;
  
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
  return self.passwordTextField;
}

#pragma mark - Keyboard

- (void) keyboardWillShow:(NSNotification *)notification {
  CGRect keyboardFrame = [((NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey]) CGRectValue];
  NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  self.bottomConstraint.constant = CGRectGetHeight(keyboardFrame) + ContextPasswordDefaultBottomInset;
  [UIView animateWithDuration:duration delay:0.0 options:(curve << 16) animations:^{
    [self.view layoutIfNeeded];
  } completion:nil];
}

- (void) keyboardWillHide:(NSNotification *)notification {
  NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  self.bottomConstraint.constant = ContextPasswordDefaultBottomInset;
  
  [UIView animateWithDuration:duration delay:0.0 options:(curve << 16) animations:^{
    [self.view layoutIfNeeded];
  } completion:nil];
}

@end
