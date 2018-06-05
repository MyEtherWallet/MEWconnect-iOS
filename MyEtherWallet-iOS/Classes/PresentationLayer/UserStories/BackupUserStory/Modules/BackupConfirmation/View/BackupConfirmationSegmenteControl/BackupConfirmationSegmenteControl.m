//
//  BackupConfirmationSegmenteControl.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationSegmenteControl.h"

static CGFloat const kBackupConfirmationSegmenteControlHeight = 56.0;

@implementation BackupConfirmationSegmenteControl

- (CGSize)intrinsicContentSize {
  return CGSizeMake(UIViewNoIntrinsicMetric, kBackupConfirmationSegmenteControlHeight);
}

@end
