//
//  RestoreOptionsNormalTableViewCell.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 2/18/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreOptionsNormalTableViewCell.h"
#import "RestoreOptionsNormalTableViewCellObject.h"

static CGFloat const kRestoreOptionsNormalTableViewCellHeight = 56.0;
static CGFloat const kRestoreOptionsNormalTableViewCellCompactHeight  = 44.0;

@interface RestoreOptionsNormalTableViewCell ()
@end

@implementation RestoreOptionsNormalTableViewCell

#pragma mark - NICell methods

- (BOOL)shouldUpdateCellWithObject:(RestoreOptionsNormalTableViewCellObject *)object {
  self.textLabel.text = object.title;
  return YES;
}

+ (CGFloat)heightForObject:(RestoreOptionsNormalTableViewCellObject *)object atIndexPath:(__unused NSIndexPath *)indexPath tableView:(__unused UITableView *)tableView {
  if (object.compact) {
    return kRestoreOptionsNormalTableViewCellCompactHeight;
  } else {
    return kRestoreOptionsNormalTableViewCellHeight;
  }
}

@end
