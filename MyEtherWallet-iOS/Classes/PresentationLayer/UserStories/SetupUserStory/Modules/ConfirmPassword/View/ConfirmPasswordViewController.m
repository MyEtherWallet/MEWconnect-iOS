//
//  ConfirmPasswordViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmPasswordViewController.h"

#import "ConfirmPasswordViewOutput.h"

#import "PasswordTextField.h"

#import "UIScreen+ScreenSizeType.h"

static NSTimeInterval kConfirmPasswordViewControllerAnimationDuration   = 0.2;
static CGFloat        kConfirmPasswordViewControllerIncorrectVOffset    = 42.0;
static CGFloat        kConfirmPasswordViewControllerCorrectVOffset      = 24.0;

@interface ConfirmPasswordViewController () <UITextFieldDelegate>
//Info
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *noPasswordDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *restoreInfoLabel;
//Password
@property (nonatomic, weak) IBOutlet PasswordTextField *passwordTextField;
//Crack meter
@property (nonatomic, strong) IBOutlet UILabel *incorrectPasswordLabel;
//Constraints
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *incorrectPasswordConstraints;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *restoreDescriptionVOffsetConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *descriptionToPasswordYOffset;
//Bar buttons
@property (nonatomic, weak) IBOutlet UIBarButtonItem *nextBarButtonItem;
//Scroll view
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation ConfirmPasswordViewController {
  CGFloat _keyboardHeight;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [self.passwordTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewSafeAreaInsetsDidChange {
  [super viewSafeAreaInsetsDidChange];
  [self _updateScrollViewInsets];
}

#pragma mark - ConfirmPasswordViewInput

- (void) setupInitialState {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.descriptionToPasswordYOffset.constant = 16.0;
  }
  { //Title label
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.maximumLineHeight = 40.0;
    paragraphStyle.minimumLineHeight = 40.0;
    paragraphStyle.lineSpacing = 0.0;
    CGFloat kern = -0.4;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      kern = -1.8;
    }
    NSDictionary *attributes = @{NSForegroundColorAttributeName: self.titleLabel.textColor,
                                 NSFontAttributeName: self.titleLabel.font,
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSKernAttributeName: @(kern)};
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text
                                                                     attributes:attributes];
  }
  { //No password
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0.0;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: self.noPasswordDescriptionLabel.textColor,
                                 NSFontAttributeName: self.noPasswordDescriptionLabel.font,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.noPasswordDescriptionLabel.text
                                                                                       attributes:attributes];
    NSRange range = [self.noPasswordDescriptionLabel.text rangeOfString:@"NO ‘Restore password’"];
    if (range.location != NSNotFound) {
      [attributedText addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
      [attributedText addAttribute:NSUnderlineColorAttributeName value:self.noPasswordDescriptionLabel.textColor range:range];
    }
    self.noPasswordDescriptionLabel.attributedText = attributedText;
  }
  { //Best password
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.0;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: self.restoreInfoLabel.textColor,
                                 NSFontAttributeName: self.restoreInfoLabel.font,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    self.restoreInfoLabel.attributedText = [[NSAttributedString alloc] initWithString:self.restoreInfoLabel.text
                                                                           attributes:attributes];
  }
  { //Next bar button
    NSMutableDictionary *normalAttributes = [[[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal] mutableCopy];
    NSMutableDictionary *disabledAttributes = [[[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateDisabled] mutableCopy];
    UIFont *font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    normalAttributes[NSFontAttributeName] = font;
    disabledAttributes[NSFontAttributeName] = font;
    [self.nextBarButtonItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    [self.nextBarButtonItem setTitleTextAttributes:normalAttributes forState:UIControlStateHighlighted];
    [self.nextBarButtonItem setTitleTextAttributes:disabledAttributes forState:UIControlStateDisabled];
  }
}

- (void) showValidPasswordInput {
  self.restoreDescriptionVOffsetConstraint.constant = kConfirmPasswordViewControllerCorrectVOffset;
  [UIView animateWithDuration:kConfirmPasswordViewControllerAnimationDuration
                        delay:0.0
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     self.incorrectPasswordLabel.alpha = 0.0;
                     [self.view layoutIfNeeded];
                   } completion:^(BOOL finished) {
                     if (finished) {
                       [NSLayoutConstraint deactivateConstraints:self.incorrectPasswordConstraints];
                       [self.incorrectPasswordLabel removeFromSuperview];
                     }
                   }];
  if (self.passwordTextField.theme != PasswordTextFieldThemeDefault) {
    [UIView transitionWithView:self.passwordTextField
                      duration:kConfirmPasswordViewControllerAnimationDuration
                       options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                      [self.passwordTextField setTheme:PasswordTextFieldThemeDefault];
                    } completion:nil];
  }
}

- (void) showInvalidPasswordInput {
  [self.view addSubview:self.incorrectPasswordLabel];
  [NSLayoutConstraint activateConstraints:self.incorrectPasswordConstraints];
  [self.view layoutIfNeeded];
  self.restoreDescriptionVOffsetConstraint.constant = kConfirmPasswordViewControllerIncorrectVOffset;
  [UIView animateWithDuration:kConfirmPasswordViewControllerAnimationDuration
                        delay:0.0
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     self.incorrectPasswordLabel.alpha = 1.0;
                     [self.view layoutIfNeeded];
                   } completion:^(__unused BOOL finished) {
                   }];
  if (self.passwordTextField.theme != PasswordTextFieldThemeRed) {
    [UIView transitionWithView:self.passwordTextField
                      duration:kConfirmPasswordViewControllerAnimationDuration
                       options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                      [self.passwordTextField setTheme:PasswordTextFieldThemeRed];
                    } completion:nil];
  }
}

- (void) disableNext {
  self.nextBarButtonItem.enabled = NO;
}

- (void) enableNext {
  self.nextBarButtonItem.enabled = YES;
}

#pragma mark - IBActions

- (IBAction) passwordDidChanged:(UITextField *)sender {
  [self.output passwordDidChanged:sender.text];
}

- (IBAction) nextAction:(__unused UIBarButtonItem *)sender {
  [self.output nextActionWithPassword:self.passwordTextField.text];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(__unused UITextField *)textField {
  [self.output nextActionWithPassword:self.passwordTextField.text];
  return NO;
}

#pragma mark - Notifications

- (void) keyboardWillShow:(NSNotification *)notification {
  CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  _keyboardHeight = keyboardSize.height;
  [self _updateScrollViewInsets];
}

- (void) keyboardWillHide:(__unused NSNotification *)notification {
  _keyboardHeight = 0.0;
  [self _updateScrollViewInsets];
}

#pragma mark - Private

- (void) _updateScrollViewInsets {
  UIEdgeInsets insets;
  if (@available(iOS 11.0, *)) {
    insets = self.scrollView.adjustedContentInset;
  } else {
    insets = self.scrollView.contentInset;
  }
  insets.bottom = _keyboardHeight;
  
  self.scrollView.contentInset = insets;
  
  UIEdgeInsets indicatorInset = self.scrollView.scrollIndicatorInsets;
  indicatorInset.bottom = _keyboardHeight;
  self.scrollView.scrollIndicatorInsets = indicatorInset;
}

@end
