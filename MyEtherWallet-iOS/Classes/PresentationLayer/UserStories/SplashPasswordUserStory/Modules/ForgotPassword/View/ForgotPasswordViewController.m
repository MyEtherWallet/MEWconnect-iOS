//
//  ForgotPasswordViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "ForgotPasswordViewController.h"

#import "ForgotPasswordViewOutput.h"

#import "UIView+LockFrame.h"
#import "UIScreen+ScreenSizeType.h"

@interface ForgotPasswordViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLabelTopYOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleToDescriptionLabelYOffsetConstraint;
@end

@implementation ForgotPasswordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

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

#pragma mark - ForgotPasswordViewInput

- (void) setupInitialState {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.titleLabelTopYOffsetConstraint.constant = 52.0;
    self.titleToDescriptionLabelYOffsetConstraint.constant = 15.0;
  }
  { //Title label
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0.0;
    style.maximumLineHeight = 40.0;
    style.minimumLineHeight = 40.0;
    NSDictionary *attributes = @{NSFontAttributeName: self.titleLabel.font,
                                 NSForegroundColorAttributeName: self.titleLabel.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(-0.3)};
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:attributes];
  }
  { //Description
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4.5;
    NSDictionary *attributes = @{NSFontAttributeName: self.descriptionLabel.font,
                                 NSForegroundColorAttributeName: self.descriptionLabel.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(-0.01)};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.descriptionLabel.text attributes:attributes];
    NSRange backupRange = [self.descriptionLabel.text rangeOfString:NSLocalizedString(@"backup", @"Forgot password. Backup word")];
    if (backupRange.location != NSNotFound) {
      [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium]
                               range:backupRange];
    }
    self.descriptionLabel.attributedText = attributedString;
  }
  [self _updatePrefferedContentSize];
}

- (void) presentResetConfirmation {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"⚠️\nWarning: you can lose your account and funds forever", @"Forgot password screen. Reset wallet alert")
                                                                 message:NSLocalizedString(@"Don't reset if you didn't make a backup, as there will be no way to restore your account after that. Resetting wallet will remove all keys saved in the local vault and bring you back to the app's start screen.", @"Forgot password screen. Reset wallet alert")
                                                          preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Forgot password screen. Reset wallet alert")
                                            style:UIAlertActionStyleCancel
                                          handler:nil]];
  @weakify(self);
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Reset wallet", @"Forgot password screen. Reset wallet alert")
                                            style:UIAlertActionStyleDestructive
                                          handler:^(__unused UIAlertAction * _Nonnull action) {
    @strongify(self);
    [self.output resetWalletConfirmedAction];
  }]];
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction) restoreAction:(__unused UIButton *)sender {
  [self.output restoreAction];
}

- (IBAction) closeAction:(__unused UIButton *)sender {
  [self.output closeAction];
}

- (IBAction) resetWallet:(__unused UIButton *)sender {
  [self.output resetWalletAction];
}

#pragma mark - Override

- (void)setCustomTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)customTransitioningDelegate {
  _customTransitioningDelegate = customTransitioningDelegate;
  self.transitioningDelegate = customTransitioningDelegate;
}

#pragma mark - Private

- (void) _updatePrefferedContentSize {
  CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
  CGRect bounds = self.presentingViewController.view.window.bounds;
  CGSize size = bounds.size;
  size.height -= CGRectGetHeight(statusBarFrame);
  size.height -= 8.0;
  if (!CGSizeEqualToSize(self.preferredContentSize, size)) {
    self.preferredContentSize = size;
  }
}

@end
