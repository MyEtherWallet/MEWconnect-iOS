//
//  BuyEtherHistoryDataDisplayManager.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Nimbus.NimbusModels;

#import "BuyEtherHistoryDataDisplayManager.h"

#import "BuyEtherHistoryDataDisplayManager.h"
#import "BuyEtherHistoryCellObjectBuilder.h"
#import "BuyEtherHistoryTableViewAnimator.h"

#import "CacheTransactionBatch.h"
#import "CacheTransaction.h"

#import "CellFactory.h"

@interface BuyEtherHistoryDataDisplayManager ()
@property (nonatomic, strong) NIMutableTableViewModel *tableViewModel;
@property (nonatomic, strong) NITableViewActions *tableViewActions;
@end

@implementation BuyEtherHistoryDataDisplayManager {
  BOOL _empty;
}

- (void)configureDataDisplayManagerWithAnimator:(BuyEtherHistoryTableViewAnimator *)animator {
  self.animator = animator;
}

- (void)updateDataDisplayManagerWithTransactionBatch:(CacheTransactionBatch *)transactionBatch {
  if (!self.tableViewModel) {
    [self updateTableViewModel];
  }
  if ([transactionBatch.insertTransactions count] > 0 && _empty) {
    if ([self.tableViewModel tableView:self.animator.tableView numberOfRowsInSection:0] == 1) { //empty
      [self.tableViewModel removeObjectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
      [self.animator reloadData];
      _empty = NO;
    }
  }
  
  for (CacheTransaction *transaction in transactionBatch.deleteTransactions) {
    NSIndexPath *removeIndexPath = [NSIndexPath indexPathForRow:transaction.oldIndexPath.row inSection:0];
    [self.tableViewModel removeObjectAtIndexPath:removeIndexPath];
  }
  
  for (CacheTransaction *transaction in transactionBatch.insertTransactions) {
    BuyEtherHistoryItemTableViewCellObject *cellObject = [self.cellObjectBuilder buildCellObjectForHistoryItem:transaction.object];
    NSUInteger updatedRow = transaction.updatedIndexPath.row;
    [self.tableViewModel insertObject:cellObject atRow:updatedRow inSection:0];
  }
  
  for (CacheTransaction *transaction in transactionBatch.moveTransactions) {
    BuyEtherHistoryItemTableViewCellObject *cellObject = [self.cellObjectBuilder buildCellObjectForHistoryItem:transaction.object];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:transaction.oldIndexPath.row inSection:0];
    [self.tableViewModel removeObjectAtIndexPath:oldIndexPath];
    [self.tableViewModel insertObject:cellObject atRow:transaction.updatedIndexPath.row inSection:0];
  }
  
  for (CacheTransaction *transaction in transactionBatch.updateTransactions) {
    BuyEtherHistoryItemTableViewCellObject *cellObject = [self.cellObjectBuilder buildCellObjectForHistoryItem:transaction.object];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:transaction.oldIndexPath.row inSection:0];
    [self.tableViewModel removeObjectAtIndexPath:oldIndexPath];
    [self.tableViewModel insertObject:cellObject atRow:transaction.updatedIndexPath.row inSection:0];
  }
  
  [self.animator updateWithTransactionBatch:transactionBatch];
  
  NSInteger numberOfModels = [self.tableViewModel tableView:self.animator.tableView numberOfRowsInSection:0];
  
  if (numberOfModels == 0) {
    _empty = YES;
    [self.tableViewModel removeSectionAtIndex:0];
    [self.tableViewModel insertSectionWithTitle:nil atIndex:0];
    [self.tableViewModel addObject:[self.cellObjectBuilder buildEmptyCellObject]];
    [self.animator reloadData];
  }
}

#pragma mark - UITableViewDelegate methods

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [CellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.tableViewModel];
}

#pragma mark - DataDisplayManager methods

- (id<UITableViewDataSource>)dataSourceForTableView:(__unused UITableView *)tableView {
  if (!self.tableViewModel) {
    [self updateTableViewModel];
  }
  return self.tableViewModel;
}

- (id<UITableViewDelegate>)delegateForTableView:(__unused UITableView *)tableView withBaseDelegate:(__unused id<UITableViewDelegate>)baseTableViewDelegate {
  if (!self.tableViewActions) {
    [self setupTableViewActions];
  }
  return [self.tableViewActions forwardingTo:self];
}

#pragma mark - Private

- (void) updateTableViewModel {
  self.tableViewModel = [[NIMutableTableViewModel alloc] initWithDelegate:(id)[CellFactory class]];
  [self.tableViewModel insertSectionWithTitle:nil atIndex:0];
}

- (void) setupTableViewActions {
  self.tableViewActions = [[NITableViewActions alloc] initWithTarget:self];
}

@end
