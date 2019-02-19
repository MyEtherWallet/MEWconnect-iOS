//
//  RestorePrepareViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestorePrepareViewController.h"

#import "RestorePrepareViewOutput.h"

#import "UIScreen+ScreenSizeType.h"

@interface RestorePrepareViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentLeftOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentRightOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *logoToTitleYOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonBottomOffsetConstraint;
@end

@implementation RestorePrepareViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.output didTriggerViewReadyEvent];
}

#pragma mark - RestorePrepareViewInput

- (void) setupInitialState {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.logoTopOffsetConstraint.constant = 24.0;
    self.contentLeftOffsetConstraint.constant = 24.0;
    self.contentRightOffsetConstraint.constant = 24.0;
    self.logoToTitleYOffsetConstraint.constant = 23.0;
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

#pragma mark - IBActions

- (IBAction) continueAction:(__unused id)sender {
  [self.output continueAction];
}

@end
