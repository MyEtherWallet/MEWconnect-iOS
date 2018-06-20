//
//  TransactionViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TransactionViewController.h"

#import "TransactionViewOutput.h"

#import "MEWConnectTransaction.h"

#import "NSNumberFormatter+Ethereum.h"

#import "MyEtherWallet_iOS-Swift.h"

@interface TransactionViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet CheckboxButton *addressCheckboxButton;
@property (nonatomic, weak) IBOutlet CheckboxButton *amountCheckboxButton;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@end

@implementation TransactionViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

#pragma mark - TransactionViewInput

- (void) setupInitialState {
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

- (void) updateWithTransaction:(MEWConnectTransaction *)transaction {
  NSNumberFormatter *formatter = [NSNumberFormatter ethereumFormatterWithChainID:[transaction.chainId integerValue]];
  NSDecimalNumber *decimalNumber = [transaction decimalValue];
  NSString *amount = [formatter stringFromNumber:decimalNumber];
  
  [self.addressCheckboxButton updateWithContentTitle:NSLocalizedString(@"Check address you’re sending to:", @"Transaction screen. Title")];
  [self.addressCheckboxButton updateWithContentText:transaction.to];
//  [self.addressCheckboxButton updateWithContentDescription:@"pay.mewtopia.eth"];
  [self.addressCheckboxButton updateWithRightImageWithSeed:transaction.to];
  
  [self.amountCheckboxButton updateWithContentTitle:@"Check the amount:"];
  [self.amountCheckboxButton updateWithContentText:amount];
//  [self.amountCheckboxButton updateWithContentDescription:@"$751.80"];
}

- (void)enableSign:(BOOL)enable {
  self.confirmButton.enabled = enable;
}

#pragma mark - IBActions

- (IBAction) confirmAction:(id)sender {
  [self.output signAction];
}

- (IBAction) declineAction:(id)sender {
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

@end
