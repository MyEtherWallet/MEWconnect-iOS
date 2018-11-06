//
//  AboutViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AboutViewController.h"

#import "AboutViewOutput.h"

#import "UIScreen+ScreenSizeType.h"

@interface AboutViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation AboutViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.textView.contentOffset = CGPointZero;
}

#pragma mark - AboutViewInput

- (void) setupInitialState {
  {
    CGFloat paragraphSpacing = 11.0;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
      paragraphSpacing = 10.0;
      self.textView.textContainerInset = UIEdgeInsetsMake(0.0, 24.0, 24.0, 24.0);
    } else {
      self.textView.textContainerInset = UIEdgeInsetsMake(0.0, 32.0, 32.0, 32.0);
    }
    NSArray *infoParts = [self.textView.text componentsSeparatedByString:@"\n"];
    NSMutableAttributedString *attributedInfoText = [[NSMutableAttributedString alloc] init];
    for (NSInteger i = 0; i < [infoParts count]; ++i) {
      NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
      style.lineSpacing = 2.0;
      if (i != [infoParts count] - 1) {
        style.paragraphSpacing = paragraphSpacing;
      }
      NSDictionary *attributes = @{NSFontAttributeName: self.textView.font,
                                   NSForegroundColorAttributeName: self.textView.textColor ?: [UIColor blackColor],
                                   NSParagraphStyleAttributeName: style,
                                   NSKernAttributeName: @(-0.01)};
      NSString *part = infoParts[i];
      if (i != [infoParts count] - 1) {
        part = [part stringByAppendingString:@"\n"];
      }
      [attributedInfoText appendAttributedString:[[NSAttributedString alloc] initWithString:part attributes:attributes]];
    }
    
    self.textView.attributedText = attributedInfoText;
  }
}

#pragma mark - IBActions

- (IBAction) closeAction:(__unused id)sender {
  [self.output closeAction];
}

@end
