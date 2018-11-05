//
//  BackupStartViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupStartViewController.h"

#import "BackupStartViewOutput.h"

#import "UIScreen+ScreenSizeType.h"

@interface BackupStartViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentLeftOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentRightOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentLeftCorrectionOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoToTitleYOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleToContentYOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonBottomOffsetConstraint;
@end

@implementation BackupStartViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [CATransaction begin];
  self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
  [CATransaction commit];
}

#pragma mark - BackupStartViewInput

- (void) setupInitialState {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.logoTopOffsetConstraint.constant = 28.0;
    self.contentLeftOffsetConstraint.constant = 24.0;
    self.contentRightOffsetConstraint.constant = 24.0;
    self.contentLeftCorrectionOffsetConstraint.constant = 0.0;
    self.logoToTitleYOffsetConstraint.constant = 19.0;
    self.titleToContentYOffsetConstraint.constant = 12.0;
    self.buttonBottomOffsetConstraint.constant = 24.0;
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
    CGFloat paragraphSpacing = 11.0;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      paragraphSpacing = 10.0;
    }
    NSArray *infoParts = [self.descriptionLabel.text componentsSeparatedByString:@"\n"];
    NSMutableAttributedString *attributedInfoText = [[NSMutableAttributedString alloc] init];
    for (NSInteger i = 0; i < [infoParts count]; ++i) {
      NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
      style.lineSpacing = 2.0;
      if (i != [infoParts count] - 1) {
        style.paragraphSpacing = paragraphSpacing;
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

#pragma mark - IBActions

- (IBAction) startAction:(__unused id)sender {
  [self.output startAction];
}

@end
