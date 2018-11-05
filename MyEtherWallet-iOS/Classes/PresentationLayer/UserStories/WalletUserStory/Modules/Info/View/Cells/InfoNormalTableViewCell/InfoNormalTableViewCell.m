//
//  InfoNormalTableViewCell.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoNormalTableViewCell.h"
#import "InfoNormalTableViewCellObject.h"

static CGFloat const kInfoNormalTableViewCellHeight = 56.0;
static CGFloat const kInfoNormalTableViewCellCompactHeight  = 44.0;

@interface InfoNormalTableViewCell ()
@end

@implementation InfoNormalTableViewCell

#pragma mark - NICell methods

- (BOOL)shouldUpdateCellWithObject:(InfoNormalTableViewCellObject *)object {
  self.textLabel.text = object.title;
  return YES;
}

+ (CGFloat)heightForObject:(InfoNormalTableViewCellObject *)object atIndexPath:(__unused NSIndexPath *)indexPath tableView:(__unused UITableView *)tableView {
  if (object.compact) {
    return kInfoNormalTableViewCellCompactHeight;
  } else {
    return kInfoNormalTableViewCellHeight;
  }
}

@end
