//
//  HomeTableViewAnimator.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@class CacheTransactionBatch;

@interface HomeTableViewAnimator : NSObject
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) BOOL animated;
- (void)updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch;
- (void)reloadData;
@end
