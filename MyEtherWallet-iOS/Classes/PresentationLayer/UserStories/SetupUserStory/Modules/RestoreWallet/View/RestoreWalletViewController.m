//
//  RestoreWalletViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;
@import UITextView_Placeholder;
@import MnemonicsView;

#import "RestoreWalletViewController.h"

#import "RestoreWalletViewOutput.h"

#import "ApplicationConstants.h"

#import "UIColor+Application.h"
#import "UIScreen+ScreenSizeType.h"

@interface RestoreWalletViewController () <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet MnemonicsView *mnemonicsView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleTopOffsetConstraint;
@end

@implementation RestoreWalletViewController {
  CGFloat _keyboardHeight;
  BOOL _keyboardWasShown;
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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.mnemonicsView becomeFirstResponder];
}

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewSafeAreaInsetsDidChange {
  [super viewSafeAreaInsetsDidChange];
  [self _updateScrollViewInsets];
}

#pragma mark - RestoreWalletViewInput

- (void) setupInitialState {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.titleTopOffsetConstraint.constant = 30.0;
  }
  { //Title label
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0.0;
    UIFont *font = self.titleLabel.font;
    CGFloat kern = 0.0;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      font = [font fontWithSize:36.0];
      style.maximumLineHeight = 36.0;
      style.minimumLineHeight = 36.0;
      kern = 0.0;
    } else {
      style.maximumLineHeight = 40.0;
      style.minimumLineHeight = 40.0;
      kern = -0.3;
    }
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: self.titleLabel.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(kern)};
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:attributes];
  }
  { //MnemonicsView
    self.mnemonicsView.layer.cornerRadius = 10.0;
    self.mnemonicsView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mnemonicsView.layer.shadowRadius = 20.0;
    self.mnemonicsView.layer.shadowOpacity = 0.2;
    self.mnemonicsView.layer.shadowOffset = CGSizeMake(0.0, 10.0);
    self.mnemonicsView.clipsToBounds = NO;
  }
}

- (void)enableNext:(BOOL)enable {
  self.nextButton.enabled = enable;
}

- (void) presentIncorrectMnemonicsWarning {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Please check your recovery phrase.", @"Restore wallet. Recovery phrase incorrect title")
                                                                 message:NSLocalizedString(@"The recovery phrase you entered doesn't seem to be valid.", @"Restore wallet. Recovery phrase incorrect message")
                                                          preferredStyle:UIAlertControllerStyleAlert];
  @weakify(self);
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"")
                                            style:UIAlertActionStyleDefault
                                          handler:^(__unused UIAlertAction * _Nonnull action) {
                                            @strongify(self);
                                            [self.mnemonicsView becomeFirstResponder];
                                          }]];
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction) cancelAction:(__unused id)sender {
  [self.output cancelAction];
}

- (IBAction) nextAction:(__unused id)sender {
  [self.output nextAction];
}

- (IBAction) mnemonicsChangedAction:(MnemonicsView *)sender {
  [self.output textDidChangedAction:sender.mnemonics];
}

#pragma mark - Notifications

- (void) keyboardWillShow:(NSNotification *)notification {
  _keyboardWasShown = YES;
  CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  _keyboardHeight = keyboardSize.height;
  [self _updateScrollViewInsets];
}

- (void) keyboardWillChangeFrame:(NSNotification *)notification {
  if (_keyboardWasShown) {
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyboardHeight = keyboardSize.height;
    [self _updateScrollViewInsets];
  }
}

- (void) keyboardWillHide:(__unused NSNotification *)notification {
  _keyboardWasShown = NO;
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
  if (@available(iOS 11.0, *)) {
    insets.bottom -= self.view.safeAreaInsets.bottom;
  }
  
  self.scrollView.contentInset = insets;
  
  UIEdgeInsets indicatorInset = self.scrollView.scrollIndicatorInsets;
  indicatorInset.bottom = _keyboardHeight;
  if (@available(iOS 11.0, *)) {
    indicatorInset.bottom -= self.view.safeAreaInsets.bottom;
  }
  self.scrollView.scrollIndicatorInsets = indicatorInset;
}

@end
