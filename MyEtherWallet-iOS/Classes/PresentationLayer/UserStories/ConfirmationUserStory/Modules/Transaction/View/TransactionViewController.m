//
//  TransactionViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#if BETA
#import "MyEtherWallet_iOS_Beta-Swift.h"
#else
#import "MyEtherWallet_iOS-Swift.h"
#endif

#import "TransactionViewController.h"

#import "TransactionViewOutput.h"

#import "MEWConnectTransaction.h"
#import "NetworkPlainObject.h"
#import "MasterTokenPlainObject.h"
#import "FiatPricePlainObject.h"

#import "NSNumberFormatter+Ethereum.h"
#import "NSNumberFormatter+USD.h"
#import "UIScreen+ScreenSizeType.h"

#import "ConfirmationUIStringList.h"

@interface TransactionViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet CheckboxButton *networkCheckboxButton;
@property (nonatomic, weak) IBOutlet CheckboxButton *addressCheckboxButton;
@property (nonatomic, weak) IBOutlet CheckboxButton *amountCheckboxButton;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonsWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *interbuttonOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descriptionToButtonVerticalOffsetConstraint;
@end

@implementation TransactionViewController

#pragma mark - LifeCycle

- (void) viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.scrollView flashScrollIndicators];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - TransactionViewInput

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
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.0;
    NSDictionary *attributes = @{NSFontAttributeName: self.descriptionLabel.font,
                                 NSForegroundColorAttributeName: self.descriptionLabel.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(-0.08)};
    self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:self.descriptionLabel.text attributes:attributes];
  }
}

- (void) updateWithTransaction:(MEWConnectTransaction *)transaction networkName:(NSString *)networkName {
  NSDecimalNumber *ethAmount = [transaction decimalValue];
  NSString *usdAmount = nil;
  NSNumberFormatter *formatter = nil;
  
  if (transaction.token) {
    formatter = [NSNumberFormatter ethereumFormatterWithCurrencySymbol:transaction.token.symbol];
    NSDecimalNumber *usdPrice = transaction.token.price.usdPrice;
    if (usdPrice) {
      NSNumberFormatter *usdFormatter = [NSNumberFormatter usdFormatter];
      NSDecimalNumber *usd = [ethAmount decimalNumberByMultiplyingBy:usdPrice];
      usdAmount = [usdFormatter stringFromNumber:usd];
    }
  } else {
    formatter = [NSNumberFormatter ethereumFormatterWithCurrencySymbol:ConfirmationUIStringList.confirmationUnknownTokenCurrencySymbol];
    usdAmount = ConfirmationUIStringList.confirmationUnknownTokenDescription;
  }
  
  NSString *amount = [formatter stringFromNumber:ethAmount];
  
  
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    [self.addressCheckboxButton updateWithContentTitle:ConfirmationUIStringList.confirmationCheckAddressShortVersion];
  } else {
    [self.addressCheckboxButton updateWithContentTitle:ConfirmationUIStringList.confirmationCheckAddressFullVersion];
  }
  
  [self.addressCheckboxButton updateWithContentText:transaction.toValue];
  [self.addressCheckboxButton updateWithRightImageWithSeed:transaction.toValue];
  
  [self.amountCheckboxButton updateWithContentTitle:ConfirmationUIStringList.confirmationCheckAmount];
  [self.amountCheckboxButton updateWithContentText:amount];
  if (usdAmount) {
    [self.amountCheckboxButton updateWithContentDescription:usdAmount];
  }
  
  if (networkName) {
    [self.networkCheckboxButton updateWithContentTitle:ConfirmationUIStringList.confirmationCheckNetwork];
    [self.networkCheckboxButton updateWithContentText:networkName];
  } else {
    [self.networkCheckboxButton removeFromSuperview];
  }
}

- (void)enableSign:(BOOL)enable {
  self.confirmButton.enabled = enable;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  CGFloat diffs = CGRectGetHeight(self.view.frame) - self.scrollView.contentSize.height;
  if (@available(iOS 11.0, *)) {
    diffs -= self.view.safeAreaInsets.bottom;
  }
  CGFloat result = MAX(self.descriptionToButtonVerticalOffsetConstraint.constant + diffs, 20.0);
  self.descriptionToButtonVerticalOffsetConstraint.constant = result;
}

#pragma mark - IBActions

- (IBAction) confirmAction:(__unused id)sender {
  [self.output signAction];
}

- (IBAction) declineAction:(__unused id)sender {
  [self.output declineAction];
}

- (IBAction)confirmAddress:(UIButton *)sender {
  sender.selected = !sender.selected;
  [self.output confirmAddressAction:sender.selected];
}

- (IBAction)confirmAmount:(UIButton *)sender {
  sender.selected = !sender.selected;
  [self.output confirmAmountAction:sender.selected];
}

- (IBAction)confirmNetwork:(UIButton *)sender {
  sender.selected = !sender.selected;
  [self.output confirmNetworkAction:sender.selected];
}

@end
