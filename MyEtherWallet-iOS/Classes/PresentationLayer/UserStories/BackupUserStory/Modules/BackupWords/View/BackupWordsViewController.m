//
//  BackupWordsViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupWordsViewController.h"

#import "BackupWordsViewOutput.h"

#import "UIColor+Application.h"
#import "UIColor+Hex.h"
#import "UIScreen+ScreenSizeType.h"

@interface BackupWordsViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIView *wordsContrainterView;
@property (nonatomic, weak) IBOutlet UILabel *wordsPart1Label;
@property (nonatomic, weak) IBOutlet UILabel *wordsPart2Label;
@property (nonatomic, weak) IBOutlet UILabel *bewareLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleToContentYOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descriptionToWordsContainerYOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wordsContainerLeftOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wordsContainerRightOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wordsPart1LeftOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wordsPart2LeftOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wordsTopOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wordsBottomOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wordsContainerToBewareYOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bewareLeftOffsetConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bewareRightOffsetConstraint;
@end

@implementation BackupWordsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [CATransaction begin];
  self.navigationController.navigationBar.barTintColor = [UIColor applicationLightBlue];
  [CATransaction commit];
  [self.output didTriggerViewWillAppearEvent];
}

- (void)viewWillDisappear:(BOOL)animated {
  [CATransaction begin];
  self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
  [CATransaction commit];
  [super viewWillDisappear:animated];
  [self.output didTriggerViewWillDisappearEvent];
}

#pragma mark - BackupWordsViewInput

- (void) setupInitialStateWithWords:(NSArray<NSString *> *)words {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    self.titleToContentYOffsetConstraint.constant = 15.0;
    self.descriptionToWordsContainerYOffsetConstraint.constant = 11.0;
    self.wordsContainerLeftOffsetConstraint.constant = 14.0;
    self.wordsContainerRightOffsetConstraint.constant = 13.0;
    self.wordsPart1LeftOffsetConstraint.constant = 21.0;
    self.wordsPart2LeftOffsetConstraint.constant = 21.0;
    self.wordsTopOffsetConstraint.constant = 14.0;;
    self.wordsBottomOffsetConstraint.constant = 15.0;
    self.wordsContainerToBewareYOffsetConstraint.constant = 10.0;
    self.bewareLeftOffsetConstraint.constant = -4.0;
    self.bewareRightOffsetConstraint.constant = 4.0;
  }
  { //Words containter shadow
    self.wordsContrainterView.layer.cornerRadius = 10.0;
    self.wordsContrainterView.layer.shadowOffset = CGSizeMake(0.0, 10.0);
    self.wordsContrainterView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.wordsContrainterView.layer.shadowRadius = 20.0;
    self.wordsContrainterView.layer.shadowOpacity = 0.2;
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
    NSDictionary *attributes = @{NSFontAttributeName: self.descriptionLabel.font,
                                 NSForegroundColorAttributeName: self.descriptionLabel.textColor,
                                 NSKernAttributeName: @(-0.01)};
    
    self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:self.descriptionLabel.text attributes:attributes];
  }
  { //Words
    NSArray *wordsPart1 = [words subarrayWithRange:NSMakeRange(0, 12)];
    [self _prepareWordsList:wordsPart1 inLabel:self.wordsPart1Label startIndex:1];
    NSArray *wordsPart2 = [words subarrayWithRange:NSMakeRange(12, 12)];
    [self _prepareWordsList:wordsPart2 inLabel:self.wordsPart2Label startIndex:13];
  }
  { //Beware label
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4.0;
    NSDictionary *attributes = @{NSFontAttributeName: self.bewareLabel.font,
                                 NSForegroundColorAttributeName: self.bewareLabel.textColor,
                                 NSKernAttributeName: @(-0.01),
                                 NSParagraphStyleAttributeName: style};
    
    self.bewareLabel.attributedText = [[NSAttributedString alloc] initWithString:self.bewareLabel.text attributes:attributes];
  }
}

- (void) showScreenshotAlert {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Oops! It looks like you've just taken a screenshot.", @"Backup. Screenshot warning title")
                                                                 message:NSLocalizedString(@"Please remember NOT to keep your passphrase anywhere digitally, otherwise you can lose all your funds.\nWe strongly suggest to delete the screenshot you've just taken and write down the passphrase using pen and paper.", @"Backup. Screenshot warning description")
                                                          preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"Backup. Screenshot action button title")
                                            style:UIAlertActionStyleDefault
                                          handler:nil]];
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction)nextAction:(__unused id)sender {
  [self.output nextAction];
}

#pragma mark - Private

- (void) _prepareWordsList:(NSArray <NSString *> *)words inLabel:(UILabel *)label startIndex:(NSInteger)index {
  CGFloat wordFontSize = 22.0;
  CGFloat lineHeight = 26.0;
  CGFloat wordsTabOffset = 26.0;
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    wordFontSize = 17.0;
    lineHeight = 22.0;
    wordsTabOffset = 22.0;
  }
  NSDictionary *idxAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular],
                                  NSForegroundColorAttributeName: [UIColor colorWithRGB:0x9D9D9D]};
  NSDictionary *wordAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:wordFontSize weight:UIFontWeightRegular],
                                   NSForegroundColorAttributeName: [UIColor darkTextColor]};
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
  for (NSInteger i = 0; i < [words count]; ++i) {
    NSString *idxText = [NSString stringWithFormat:@"%zd\t", i + index];
    NSString *wordText = [NSString stringWithFormat:@"%@%@", words[i], i+1 != [words count] ? @"\n" : @""];
    
    NSAttributedString *idxAttributedText = [[NSAttributedString alloc] initWithString:idxText attributes:idxAttributes];
    NSAttributedString *wordAttributedText = [[NSAttributedString alloc] initWithString:wordText attributes:wordAttributes];
    
    [attributedString appendAttributedString:idxAttributedText];
    [attributedString appendAttributedString:wordAttributedText];
  }
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  NSTextTab *zeroTab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentNatural location:0.0 options:@{}];
  NSTextTab *textTab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentNatural location:wordsTabOffset options:@{}];
  style.tabStops = @[zeroTab, textTab];
  style.lineSpacing = 6.0;

  style.maximumLineHeight = style.minimumLineHeight = lineHeight;
  [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [attributedString length])];
  label.attributedText = attributedString;
}

@end
