//
//  BuyEtherHistoryTableViewAnimator.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@class CacheTransactionBatch;

@interface BuyEtherHistoryTableViewAnimator : NSObject
@property (nonatomic, weak) UITableView *tableView;
- (void) reloadData;
- (void) updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch;
@end
