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

static NSTimeInterval kConfirmPasswordViewControllerAnimationDuration   = 0.2;
static CGFloat        kConfirmPasswordViewControllerIncorrectVOffset    = 42.0;
static CGFloat        kConfirmPasswordViewControllerCorrectVOffset      = 24.0;

@interface ConfirmPasswordViewController ()
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
//Bar buttons
@property (nonatomic, weak) IBOutlet UIBarButtonItem *nextBarButtonItem;
@end

@implementation ConfirmPasswordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.passwordTextField becomeFirstResponder];
}

#pragma mark - ConfirmPasswordViewInput

- (void) setupInitialState {
  { //Title label
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.maximumLineHeight = 40.0;
    paragraphStyle.minimumLineHeight = 40.0;
    paragraphStyle.lineSpacing = 0.0;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: self.titleLabel.textColor,
                                 NSFontAttributeName: self.titleLabel.font,
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSKernAttributeName: @(-0.4)};
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
                   } completion:^(BOOL finished) {
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

- (IBAction) nextAction:(UIBarButtonItem *)sender {
  [self.output nextAction];
}

@end
