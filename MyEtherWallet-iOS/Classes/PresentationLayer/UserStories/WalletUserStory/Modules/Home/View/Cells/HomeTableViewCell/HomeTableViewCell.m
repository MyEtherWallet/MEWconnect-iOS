//
//  HomeTableViewCell.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "HomeTableViewCellObject.h"

static CGFloat const kHomeTableViewCellHeight = 56.0;

@interface HomeTableViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *tokenNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *tokenPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *tokenBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *fiatBalanceLabel;
@end

@implementation HomeTableViewCell

#pragma mark - NICell methods

- (BOOL)shouldUpdateCellWithObject:(HomeTableViewCellObject *)object {
  self.tokenNameLabel.text = object.tokenName;
  self.tokenBalanceLabel.text = object.tokenBalance;
  self.tokenPriceLabel.text = object.tokenPrice;
  self.fiatBalanceLabel.text = object.fiatBalance;
  return YES;
}

+ (CGFloat)heightForObject:(__unused id)object atIndexPath:(__unused NSIndexPath *)indexPath tableView:(__unused UITableView *)tableView {
  return kHomeTableViewCellHeight;
}

@end
