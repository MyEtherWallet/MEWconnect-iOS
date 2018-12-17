//
//  MessageSignerViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MessageSignerViewController.h"

#import "MessageSignerViewOutput.h"

#import "MEWConnectMessage.h"

#import "UIScreen+ScreenSizeType.h"

@interface MessageSignerViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *messageTextView;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonsWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *interbuttonOffsetConstraint;

@end

@implementation MessageSignerViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.messageTextView flashScrollIndicators];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.messageTextView.contentOffset = CGPointZero;
}

#pragma mark - MessageSignerViewInput

- (void) setupInitialState {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.titleTopOffsetConstraint.constant = 24.0;
    self.buttonsWidthConstraint.constant = 0.0;
    self.interbuttonOffsetConstraint.constant = 8.0;
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
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      [self.descriptionLabel removeFromSuperview];
    } else {
      NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
      style.lineSpacing = 3.0;
      NSDictionary *attributes = @{NSFontAttributeName: self.descriptionLabel.font,
                                   NSForegroundColorAttributeName: self.descriptionLabel.textColor,
                                   NSParagraphStyleAttributeName: style,
                                   NSKernAttributeName: @(-0.08)};
      self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:self.descriptionLabel.text attributes:attributes];
    }
  }
  self.messageTextView.textContainerInset = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);
  self.messageTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0, 0.0, 4.0, 0.0);
}

- (void) updateWithMessage:(MEWConnectMessage *)message {
  self.messageTextView.text = message.message;
}

#pragma mark - IBAction

- (IBAction)signAction:(__unused id)sender {
  [self.output signAction];
}

- (IBAction)declineAction:(__unused id)sender {
  [self.output declineAction];
}

@end
