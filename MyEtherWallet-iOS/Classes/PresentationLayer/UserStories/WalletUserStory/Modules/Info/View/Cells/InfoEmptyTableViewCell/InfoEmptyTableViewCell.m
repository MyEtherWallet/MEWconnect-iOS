//
//  InfoEmptyTableViewCell.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoEmptyTableViewCell.h"
#import "InfoEmptyTableViewCellObject.h"

static CGFloat const kInfoEmptyTableViewCellHeight = 1.0;

@implementation InfoEmptyTableViewCell

#pragma mark - NICell methods

- (BOOL)shouldUpdateCellWithObject:(__unused InfoEmptyTableViewCellObject *)object {
  return NO;
}

+ (CGFloat)heightForObject:(__unused id)object atIndexPath:(__unused NSIndexPath *)indexPath tableView:(__unused UITableView *)tableView {
  return kInfoEmptyTableViewCellHeight;
}

@end
