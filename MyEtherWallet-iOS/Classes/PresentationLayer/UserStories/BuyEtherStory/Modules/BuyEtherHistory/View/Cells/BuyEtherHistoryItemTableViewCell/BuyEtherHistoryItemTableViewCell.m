//
//  BuyEtherHistoryItemTableViewCell.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryItemTableViewCell.h"
#import "BuyEtherHistoryItemTableViewCellObject.h"

#import "UIColor+Application.h"
#import "UIColor+Hex.h"

static CGFloat const kBuyEtherHistoryItemTableViewCellHeight = 90.0;

@interface BuyEtherHistoryItemTableViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@end

@implementation BuyEtherHistoryItemTableViewCell

#pragma mark - NICell methods

- (BOOL)shouldUpdateCellWithObject:(BuyEtherHistoryItemTableViewCellObject *)object {
  self.dateLabel.text = object.date;
  self.statusLabel.text = object.statusString;
  self.amountLabel.text = object.amount;
  switch (object.status) {
    case SimplexServicePaymentStatusTypeApproved: {
      self.statusLabel.textColor = [UIColor colorWithRGB:0x2E3033];
      break;
    }
    case SimplexServicePaymentStatusTypeDeclined: {
      self.statusLabel.textColor = [UIColor weakColor];
      break;
    }
    case SimplexServicePaymentStatusTypeInProgress: {
      self.statusLabel.textColor = [UIColor mainApplicationColor];
      break;
    }
    default:
      break;
  }
  return YES;
}

+ (CGFloat)heightForObject:(__unused id)object atIndexPath:(__unused NSIndexPath *)indexPath tableView:(__unused UITableView *)tableView {
  return kBuyEtherHistoryItemTableViewCellHeight;
}

@end
