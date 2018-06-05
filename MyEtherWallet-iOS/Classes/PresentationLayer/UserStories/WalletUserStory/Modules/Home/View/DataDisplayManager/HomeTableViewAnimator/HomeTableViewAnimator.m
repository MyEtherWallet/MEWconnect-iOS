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
  if (![transactionBatch isEmpty] && self.tableView) {
    [self.tableView reloadData];
//    [self.tableView beginUpdates];
//
//    { //Insert
//      NSMutableArray <NSIndexPath *> *indexPaths = [[NSMutableArray alloc] init];
//      for (CacheTransaction *transaction in transactionBatch.insertTransactions) {
//        NSUInteger updatedRow = transaction.updatedIndexPath.row;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:updatedRow inSection:0];
//        [indexPaths addObject:indexPath];
//      }
//      [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    }
//    { //Update
//      NSMutableArray <NSIndexPath *> *indexPaths = [[NSMutableArray alloc] init];
//      for (CacheTransaction *transaction in transactionBatch.updateTransactions) {
//        NSUInteger updatedRow = transaction.updatedIndexPath.row;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:updatedRow inSection:0];
//        [indexPaths addObject:indexPath];
//      }
//      [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    }
//    { //Remove
//      NSMutableArray <NSIndexPath *> *indexPaths = [[NSMutableArray alloc] init];
//      for (CacheTransaction *transaction in transactionBatch.deleteTransactions) {
//        NSUInteger updatedRow = transaction.oldIndexPath.row;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:updatedRow inSection:0];
//        [indexPaths addObject:indexPath];
//      }
//      [self.tableView reloadRowsAtIndexPaths:[[indexPaths reverseObjectEnumerator] allObjects] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    [self.tableView endUpdates];
  }
}

@end
