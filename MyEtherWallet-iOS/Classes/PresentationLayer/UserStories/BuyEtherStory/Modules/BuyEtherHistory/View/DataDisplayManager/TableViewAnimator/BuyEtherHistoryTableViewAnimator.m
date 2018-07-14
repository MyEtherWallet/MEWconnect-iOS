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

- (void) updateCellWithIndexPath:(NSIndexPath *)indexPath withCellObject:(id)cellObject {
  UITableViewCell<NICell> *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  [cell shouldUpdateCellWithObject:cellObject];
}

- (void)reloadData {
  [self.tableView reloadData];
}

- (void)updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch {
  if (![transactionBatch isEmpty]) {
    [self.tableView beginUpdates];
    NSMutableArray <NSIndexPath *> *insertRows = [[NSMutableArray alloc] initWithCapacity:[transactionBatch.insertTransactions count]];
    NSMutableArray <NSIndexPath *> *reloadRows = [[NSMutableArray alloc] initWithCapacity:[transactionBatch.updateTransactions count]];
    NSMutableArray <NSIndexPath *> *deleteRows = [[NSMutableArray alloc] initWithCapacity:[transactionBatch.deleteTransactions count]];
    for (CacheTransaction *transaction in transactionBatch.insertTransactions) {
      [insertRows addObject:transaction.updatedIndexPath];
    }
    for (CacheTransaction *transaction in transactionBatch.updateTransactions) {
      [reloadRows addObject:transaction.updatedIndexPath];
    }
    for (CacheTransaction *transaction in transactionBatch.deleteTransactions) {
      [deleteRows addObject:transaction.oldIndexPath];
    }
    [self.tableView insertRowsAtIndexPaths:insertRows withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView deleteRowsAtIndexPaths:deleteRows withRowAnimation:UITableViewRowAnimationAutomatic];
    for (CacheTransaction *transaction in transactionBatch.moveTransactions) {
      [self.tableView moveRowAtIndexPath:transaction.oldIndexPath toIndexPath:transaction.updatedIndexPath];
    }
    [self.tableView endUpdates];
  }
}

@end
