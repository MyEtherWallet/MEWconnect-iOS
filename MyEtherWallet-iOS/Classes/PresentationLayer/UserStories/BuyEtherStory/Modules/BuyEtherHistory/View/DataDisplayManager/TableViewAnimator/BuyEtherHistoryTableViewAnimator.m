//
//  BuyEtherHistoryTableViewAnimator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Nimbus.NICellFactory;

#import "BuyEtherHistoryTableViewAnimator.h"

#import "CacheTransactionBatch.h"
#import "CacheTransaction.h"

@implementation BuyEtherHistoryTableViewAnimator

- (void)updateCellWithIndexPath:(NSIndexPath *)indexPath withCellObject:(id)cellObject {
  UITableViewCell<NICell> *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  [cell shouldUpdateCellWithObject:cellObject];
}

- (void)reloadData {
  [self.tableView reloadData];
}

- (void)updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch {
  if (![transactionBatch isEmpty] && self.tableView) {
    [self.tableView reloadData];
  }
}

@end
