//
//  BackupConfirmationSegmentedControl.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationSegmentedControl.h"

static CGFloat const kBackupConfirmationSegmenteControlHeight = 56.0;

@implementation BackupConfirmationSegmentedControl

- (CGSize)intrinsicContentSize {
  return CGSizeMake(UIViewNoIntrinsicMetric, kBackupConfirmationSegmenteControlHeight);
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
