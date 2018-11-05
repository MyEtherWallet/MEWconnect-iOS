//
//  BuyEtherHistoryEmptyTableViewCell.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryEmptyTableViewCell.h"
#import "BuyEtherHistoryEmptyTableViewCellObject.h"

@interface BuyEtherHistoryEmptyTableViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation BuyEtherHistoryEmptyTableViewCell

#pragma mark - NICell methods

- (BOOL)shouldUpdateCellWithObject:(BuyEtherHistoryEmptyTableViewCellObject *)object {
  self.titleLabel.text = object.title;
  return YES;
}

+ (CGFloat)heightForObject:(__unused id)object atIndexPath:(__unused NSIndexPath *)indexPath tableView:(UITableView *)tableView {
  if (@available(iOS 11.0, *)) {
    return CGRectGetHeight(tableView.frame) - tableView.adjustedContentInset.top;
  } else {
    return CGRectGetHeight(tableView.frame) - tableView.contentInset.top;;
  }
}

@end
