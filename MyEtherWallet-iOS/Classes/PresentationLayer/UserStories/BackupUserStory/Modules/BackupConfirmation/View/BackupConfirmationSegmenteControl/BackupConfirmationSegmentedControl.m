//
//  BackupConfirmationSegmentedControl.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationSegmentedControl.h"

static CGFloat const kBackupConfirmationSegmentedControlHeight        = 56.0;
static CGFloat const kBackupConfirmationSegmentedControlCompactHeight = 44.0;

@implementation BackupConfirmationSegmentedControl

- (void)setCompact:(BOOL)compact {
  if (_compact != compact) {
    _compact = compact;
    [self invalidateIntrinsicContentSize];
  }
}

- (CGSize)intrinsicContentSize {
  CGFloat height = kBackupConfirmationSegmentedControlHeight;
  if (self.compact) {
    height = kBackupConfirmationSegmentedControlCompactHeight;
  }
  return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
  [super touchesEnded:touches withEvent:event];
  if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
    [self setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
  }
}

@end
