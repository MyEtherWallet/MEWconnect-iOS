//
//  BuyEtherHistoryItemTableViewCellObject.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryItemTableViewCellObject.h"
#import "BuyEtherHistoryItemTableViewCell.h"

#import "PurchaseHistoryPlainObject.h"

#import "NSNumberFormatter+USD.h"

@implementation BuyEtherHistoryItemTableViewCellObject

- (instancetype) initWithPurchaseHistoryItem:(PurchaseHistoryPlainObject *)purchaseHistoryItem {
  self = [super init];
  if (self) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    _date = [[dateFormatter stringFromDate:purchaseHistoryItem.date] stringByAppendingString:@" via Simplex"];
    
    NSNumberFormatter *usdFormatter = [NSNumberFormatter usdFormatter];
    _amount = [usdFormatter stringFromNumber:purchaseHistoryItem.amount];
    
    _status = [purchaseHistoryItem.status shortValue];
    switch (_status) {
      case SimplexServicePaymentStatusTypeApproved: {
        _statusString = NSLocalizedString(@"Successful", @"Purchase history. Transaction status");
        break;
      }
      case SimplexServicePaymentStatusTypeDeclined: {
        _statusString = NSLocalizedString(@"Failed", @"Purchase history. Transaction status");
        break;
      }
      case SimplexServicePaymentStatusTypeInProgress: {
        _statusString = NSLocalizedString(@"In progress", @"Purchase history. Transaction status");
        break;
      }
      case SimplexServicePaymentStatusTypeUnknown:
      default: {
        break;
      }
    }
  }
  return self;
}

+ (instancetype)objectWithPurchaseHistoryItem:(PurchaseHistoryPlainObject *)purchaseHistoryItem {
  return [[[self class] alloc] initWithPurchaseHistoryItem:purchaseHistoryItem];
}

#pragma mark - NICellObject

- (Class)cellClass {
  return [BuyEtherHistoryItemTableViewCell class];
}

#pragma mark - NINibCellObject

- (UINib *)cellNib {
  return [UINib nibWithNibName:NSStringFromClass([BuyEtherHistoryItemTableViewCell class]) bundle:[NSBundle mainBundle]];
}

@end
