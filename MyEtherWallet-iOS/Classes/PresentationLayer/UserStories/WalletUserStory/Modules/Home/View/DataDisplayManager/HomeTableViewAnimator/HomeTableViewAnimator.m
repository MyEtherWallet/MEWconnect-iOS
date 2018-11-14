//
//  HomeTableViewAnimator.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Nimbus.NICellFactory;

#import "HomeTableViewAnimator.h"

#import "CacheTransactionBatch.h"
#import "CacheTransaction.h"

@implementation HomeTableViewAnimator

- (void)updateCellWithIndexPath:(NSIndexPath *)indexPath withCellObject:(id)cellObject {
  UITableViewCell<NICell> *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  [cell shouldUpdateCellWithObject:cellObject];
}

- (void)reloadData {
  [self.tableView reloadData];
}

- (void)updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch {
  if (!self.animated) {
    [self reloadData];
    return;
  }
  if (![transactionBatch isEmpty] && self.tableView) {
    [self.tableView beginUpdates];
    for (CacheTransaction *transaction in transactionBatch.deleteTransactions) {
      [self.tableView deleteRowsAtIndexPaths:@[transaction.oldIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    for (CacheTransaction *transaction in transactionBatch.insertTransactions) {
      [self.tableView insertRowsAtIndexPaths:@[transaction.updatedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    for (CacheTransaction *transaction in transactionBatch.updateTransactions) {
      [self.tableView reloadRowsAtIndexPaths:@[transaction.updatedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    for (CacheTransaction *transaction in transactionBatch.moveTransactions) {
      [self.tableView moveRowAtIndexPath:transaction.oldIndexPath toIndexPath:transaction.updatedIndexPath];
    }
    
    [self.tableView endUpdates];
  }
}

@end
