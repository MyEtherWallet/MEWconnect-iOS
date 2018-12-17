//
//  BackupConfirmationViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationViewController.h"

#import "BackupConfirmationViewOutput.h"

#import "BackupConfirmationSegmentedControl.h"

#import "BackupConfirmationQuiz.h"

#import "UIScreen+ScreenSizeType.h"

@interface BackupConfirmationViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray <UILabel *> *questionTitleLabels;
@property (nonatomic, strong) IBOutletCollection(BackupConfirmationSegmentedControl) NSArray <BackupConfirmationSegmentedControl *> *questionSegmentedControls;
@property (nonatomic, weak) IBOutlet UILabel *bewareLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *finishButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleTopOffsetConstraint;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray <NSLayoutConstraint *> *questionTitleToQuestionYOffsetConstraints;
@end

@implementation BackupConfirmationViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.output didTriggerViewWillAppearEvent];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.output didTriggerViewWillDisappearEvent];
}

#pragma mark - BackupConfirmationViewInput

- (void) setupInitialStateWithQuiz:(BackupConfirmationQuiz *)quiz {
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40) {
    for (BackupConfirmationSegmentedControl *segmentedControl in self.questionSegmentedControls) {
      segmentedControl.compact = YES;
    }
    self.titleTopOffsetConstraint.constant = 15.0;
    for (NSLayoutConstraint *constraint in self.questionTitleToQuestionYOffsetConstraints) {
      constraint.constant = 10.0;
    }
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
  { //Beware label
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4.0;
    NSDictionary *attributes = @{NSFontAttributeName: self.bewareLabel.font,
                                 NSForegroundColorAttributeName: self.bewareLabel.textColor,
                                 NSKernAttributeName: @(-0.01),
                                 NSParagraphStyleAttributeName: style};
    
    self.bewareLabel.attributedText = [[NSAttributedString alloc] initWithString:self.bewareLabel.text attributes:attributes];
  }
  {
    NSArray *titles = [self.questionTitleLabels sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(tag)) ascending:YES]]];
    NSUInteger currentIndex = [quiz.wordsIndexes firstIndex];
    for (UILabel *title in titles) {
      title.text = [NSString stringWithFormat:NSLocalizedString(@"Select word #%tu", @""), currentIndex+1];
      currentIndex = [quiz.wordsIndexes indexGreaterThanIndex: currentIndex];
      if (currentIndex == NSNotFound) {
        break;
      }
    }
    NSArray *segmentedControls = [self.questionSegmentedControls sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(tag)) ascending:YES]]];
    NSInteger question = 0;
    for (BackupConfirmationSegmentedControl *segmentedControl in segmentedControls) {
      for (NSInteger wordIdx = 0; wordIdx < quiz.questionSize; ++wordIdx) {
        NSInteger idx = question * quiz.questionSize + wordIdx;
        if (idx >= [quiz.questionWords count]) {
          break;
        }
        [segmentedControl setTitle:quiz.questionWords[idx] forSegmentAtIndex:wordIdx];
      }
      ++question;
    }
  }
}

- (void) enableFinish:(BOOL)enable {
  self.finishButton.enabled = enable;
}

#pragma mark - IBActions

- (IBAction)answerSelected:(__unused UISegmentedControl *)sender {
  NSArray *segmentedControls = [self.questionSegmentedControls sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(tag)) ascending:YES]]];
  NSMutableArray *checkVector = [[NSMutableArray alloc] init];
  for (BackupConfirmationSegmentedControl *segmentedControl in segmentedControls) {
    NSInteger idx = [segmentedControl selectedSegmentIndex];
    if (idx < 0) {
      return;
    }
    NSString *value = [segmentedControl titleForSegmentAtIndex:idx];
    if (value) {
      [checkVector addObject:value];
    } else {
      return;
    }
  }
  [self.output didSelectAnswers:checkVector];
}

- (IBAction)finishAction:(__unused id)sender {
  [self.output finishAction];
}

@end
