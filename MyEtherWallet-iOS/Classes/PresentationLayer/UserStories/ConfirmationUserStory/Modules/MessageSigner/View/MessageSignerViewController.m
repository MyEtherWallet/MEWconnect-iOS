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
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentLeftOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentRightOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoToTitleYOffsetConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonsWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *interbuttonOffsetConstraint;

@end

@implementation MessageSignerViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - MessageSignerViewInput

- (void) setupInitialState {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.buttonsWidthConstraint.constant = 0.0;
    self.interbuttonOffsetConstraint.constant = 8.0;
    
    self.logoTopOffsetConstraint.constant = 24.0;
    self.logoToTitleYOffsetConstraint.constant = 23.0;
  }
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    
  }
  { //Title label
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0.0;
    UIFont *font = self.titleLabel.font;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      font = [font fontWithSize:36.0];
      style.maximumLineHeight = 36.0;
      style.minimumLineHeight = 36.0;
    } else {
      style.maximumLineHeight = 40.0;
      style.minimumLineHeight = 40.0;
    }
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: self.titleLabel.textColor,
                                 NSParagraphStyleAttributeName: style,
                                 NSKernAttributeName: @(-0.3)};
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:attributes];
  }
  { //Description
    NSArray *infoParts = [self.descriptionLabel.text componentsSeparatedByString:@"\n"];
    NSMutableAttributedString *attributedInfoText = [[NSMutableAttributedString alloc] init];
    for (NSInteger i = 0; i < [infoParts count]; ++i) {
      NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
      style.lineSpacing = 2.0;
      if (i != [infoParts count] - 1) {
        style.paragraphSpacing = 9.0;
      }
      NSDictionary *attributes = @{NSFontAttributeName: self.descriptionLabel.font,
                                   NSForegroundColorAttributeName: self.descriptionLabel.textColor,
                                   NSParagraphStyleAttributeName: style,
                                   NSKernAttributeName: @(-0.01)};
      NSString *part = infoParts[i];
      if (i != [infoParts count] - 1) {
        part = [part stringByAppendingString:@"\n"];
      }
      [attributedInfoText appendAttributedString:[[NSAttributedString alloc] initWithString:part attributes:attributes]];
    }
    
    self.descriptionLabel.attributedText = attributedInfoText;
  }
}

- (void) updateWithMessage:(__unused MEWConnectMessage *)message {
}

#pragma mark - IBAction

- (IBAction)signAction:(__unused id)sender {
  [self.output signAction];
}

- (IBAction)declineAction:(__unused id)sender {
  [self.output declineAction];
}

@end
