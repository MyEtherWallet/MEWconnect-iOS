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

@interface BackupConfirmationViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *questionTitleLabels;
@property (nonatomic, strong) IBOutletCollection(BackupConfirmationSegmentedControl) NSArray *questionSegmentedControls;
@property (nonatomic, weak) IBOutlet UILabel *bewareLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *finishButton;
@end

@implementation BackupConfirmationViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

#pragma mark - BackupConfirmationViewInput

- (void) setupInitialStateWithQuiz:(BackupConfirmationQuiz *)quiz {
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

- (IBAction)answerSelected:(UISegmentedControl *)sender {
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

- (IBAction)finishAction:(id)sender {
  [self.output finishAction];
}

@end
