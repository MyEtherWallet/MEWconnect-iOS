//
//  PasswordViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import YLProgressBar;

#import "PasswordViewController.h"

#import "PasswordViewOutput.h"

#import "UIColor+Application.h"
#import "UIColor+Hex.h"

static NSTimeInterval kPasswordViewControllerAnimationDuration    = 0.2;
static CGFloat        kPasswordViewControllerWCrackMeterVOffset   = 54.0;
static CGFloat        kPasswordViewControllerWOCrackMeterVOffset  = 24.0;

@interface PasswordViewController ()
//Info
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *bestPasswordDescriptionLabel;
//Password
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
//Crack meter
@property (nonatomic, strong) IBOutlet UILabel *crackMeterLabel;
@property (nonatomic, strong) IBOutlet YLProgressBar *crackMeterProgress;
//Constraints
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *crackMeterConstraints;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *passwordDescriptionVOffsetConstraint;
//Bar buttons
@property (nonatomic, weak) IBOutlet UIBarButtonItem *nextBarButtonItem;
//Scroll view
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation PasswordViewController {
  PasswordScoreTheme _scoreTheme;
  CGFloat _keyboardHeight;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [self.passwordTextField becomeFirstResponder];
}

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewSafeAreaInsetsDidChange {
  [super viewSafeAreaInsetsDidChange];
  [self _updateScrollViewInsets];
}

#pragma mark - PasswordViewInput

- (void) setupInitialStateWithBackButton:(BOOL)backButton {
  if (!backButton) {
    self.navigationItem.leftBarButtonItem = nil;
  }
  _scoreTheme = PasswordScoreThemeUnknown;
  [self updateScore:PasswordScoreThemeLWeak animated:NO];
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
  { //Best password
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.0;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: self.bestPasswordDescriptionLabel.textColor,
                                 NSFontAttributeName: self.bestPasswordDescriptionLabel.font,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    self.bestPasswordDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:self.bestPasswordDescriptionLabel.text
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

- (void) showCrackMeterIfNeeded {
  self.nextBarButtonItem.enabled = YES;
  [self.view addSubview:self.crackMeterLabel];
  [self.view addSubview:self.crackMeterProgress];
  [NSLayoutConstraint activateConstraints:self.crackMeterConstraints];
  [self.view layoutIfNeeded];
  self.passwordDescriptionVOffsetConstraint.constant = kPasswordViewControllerWCrackMeterVOffset;
  [UIView animateWithDuration:kPasswordViewControllerAnimationDuration
                        delay:0.0
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     self.crackMeterProgress.alpha = 1.0;
                     self.crackMeterLabel.alpha = 1.0;
                     [self.view layoutIfNeeded];
                   } completion:nil];
}

- (void) hideCrackMeter {
  self.nextBarButtonItem.enabled = NO;
  self.passwordDescriptionVOffsetConstraint.constant = kPasswordViewControllerWOCrackMeterVOffset;
  [UIView animateWithDuration:kPasswordViewControllerAnimationDuration
                        delay:0.0
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     self.crackMeterProgress.alpha = 0.0;
                     self.crackMeterLabel.alpha = 0.0;
                     [self.view layoutIfNeeded];
                   } completion:^(BOOL finished) {
                     if (finished) {
                       [NSLayoutConstraint deactivateConstraints:self.crackMeterConstraints];
                       [self.crackMeterProgress removeFromSuperview];
                       [self.crackMeterLabel removeFromSuperview];
                       [self updateScore:PasswordScoreThemeLWeak animated:NO];
                     }
                   }];
}

- (void) updateScore:(PasswordScoreTheme)score animated:(BOOL)animated {
  if (_scoreTheme != score) {
    _scoreTheme = score;
    NSString *text = nil;
    UIColor *color = [UIColor blackColor];
    CGFloat progress = 0.0f;
    switch (_scoreTheme) {
      case PasswordScoreThemeLWeak:
      case PasswordScoreThemeWeak: {
        text = NSLocalizedString(@"Weak", @"New wallet password");
        color = [UIColor weakColor];
        progress = 0.25f;
        break;
      }
      case PasswordScoreThemeSoSo: {
        text = NSLocalizedString(@"So-so", @"New wallet password");
        color = [UIColor sosoColor];
        progress = 0.5f;
        break;
      }
      case PasswordScoreThemeGood: {
        text = NSLocalizedString(@"Good", @"New wallet password");
        color = [UIColor goodColor];
        progress = 0.75f;
        break;
      }
      case PasswordScoreThemeGreat: {
        text = NSLocalizedString(@"Great!", @"New wallet password");
        color = [UIColor greatColor];
        progress = 1.0f;
        break;
      }
      default:
        break;
    }
    if (animated) {
    [UIView animateWithDuration:kPasswordViewControllerAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                       [self.crackMeterProgress setProgress:progress animated:YES];
                     } completion:nil];
    [UIView transitionWithView:self.crackMeterProgress
                      duration:kPasswordViewControllerAnimationDuration
                       options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                      [self.crackMeterProgress setProgressTintColor:color];
                    } completion:nil];
    [UIView transitionWithView:self.crackMeterLabel
                      duration:kPasswordViewControllerAnimationDuration
                       options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                      self.crackMeterLabel.text = text;
                      self.crackMeterLabel.textColor = color;
                    } completion:nil];
    } else {
      [self.crackMeterProgress setProgress:progress animated:YES];
      [self.crackMeterProgress setProgressTintColor:color];
      self.crackMeterLabel.text = text;
      self.crackMeterLabel.textColor = color;
    }
  }
}

#pragma mark - IBActions

- (IBAction) passwordDidChanged:(UITextField *)sender {
  [self.output passwordDidChanged:sender.text];
}

- (IBAction) cancelAction:(__unused UIBarButtonItem *)sender {
  [self.output cancelAction];
}

- (IBAction) nextAction:(__unused UIBarButtonItem *)sender {
  [self.output nextAction];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(__unused UITextField *)textField {
  [self.output nextAction];
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
