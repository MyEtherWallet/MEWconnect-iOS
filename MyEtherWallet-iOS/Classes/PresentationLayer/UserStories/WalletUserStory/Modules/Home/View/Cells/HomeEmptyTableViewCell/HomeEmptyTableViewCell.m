//
//  HomeEmptyTableViewCell.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomeEmptyTableViewCell.h"
#import "HomeEmptyTableViewCellObject.h"

@implementation HomeEmptyTableViewCell

#pragma mark - NICell methods

- (BOOL)shouldUpdateCellWithObject:(__unused HomeEmptyTableViewCellObject *)object {
  return NO;
}

+ (CGFloat)heightForObject:(__unused id)object atIndexPath:(__unused NSIndexPath *)indexPath tableView:(UITableView *)tableView {
  if (@available(iOS 11.0, *)) {
    return CGRectGetHeight(tableView.frame) - tableView.adjustedContentInset.top;
  } else {
    return CGRectGetHeight(tableView.frame) - tableView.contentInset.top;;
  }
}

@end
