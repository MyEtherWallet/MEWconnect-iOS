//
//  RestoreSafetyViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSafetyViewController.h"

#import "RestoreSafetyViewOutput.h"

#import "UIScreen+ScreenSizeType.h"

@interface RestoreSafetyViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@end

@implementation RestoreSafetyViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.scrollView flashScrollIndicators];
}

#pragma mark - RestoreSafetyViewInput

- (void) setupInitialState {
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
      NSMutableAttributedString *attributedPart = [[NSMutableAttributedString alloc] initWithString:part attributes:attributes];
      if ([part hasPrefix:@"Because"]) {
        NSRange firstNewRange = [part rangeOfString:@"new"];
        if (firstNewRange.location != NSNotFound) {
          UIFont *font = [UIFont systemFontOfSize:self.descriptionLabel.font.fontDescriptor.pointSize weight:UIFontWeightBold];
          [attributedPart addAttribute:NSFontAttributeName value:font range:firstNewRange];
        }
      }
      [attributedInfoText appendAttributedString:attributedPart];
    }
    
    self.descriptionLabel.attributedText = attributedInfoText;
  }
}

@end
