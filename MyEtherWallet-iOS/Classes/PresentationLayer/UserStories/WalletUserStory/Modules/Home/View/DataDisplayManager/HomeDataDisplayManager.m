//
//  HomeDataDisplayManager.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Nimbus.NimbusModels;

#import "HomeDataDisplayManager.h"

#import "HomeTableViewAnimator.h"
#import "HomeCellObjectBuilder.h"

#import "CacheTransactionBatch.h"
#import "CacheTransaction.h"

#import "CellFactory.h"

@interface HomeDataDisplayManager ()
@property (nonatomic, strong) NIMutableTableViewModel *tableViewModel;
@property (nonatomic, strong) NITableViewActions *tableViewActions;
@end

@implementation HomeDataDisplayManager {
  BOOL _empty;
}

- (void)configureDataDisplayManagerWithAnimator:(HomeTableViewAnimator *)animator {
  self.animator = animator;
}

- (void)updateDataDisplayManagerWithTransactionBatch:(CacheTransactionBatch *)transactionBatch maximumCount:(NSUInteger)maximumCount {
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
  NSMutableOrderedSet *insertTransactions = [transactionBatch.insertTransactions mutableCopy];
  [insertTransactions sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updatedIndexPath.row" ascending:YES]]];
  for (CacheTransaction *transaction in insertTransactions) {
    HomeTableViewCellObject *cellObject = [self.cellObjectBuilder buildCellObjectForToken:transaction.object];
    NSUInteger updatedRow = transaction.updatedIndexPath.row;
    [self.tableViewModel insertObject:cellObject atRow:updatedRow inSection:0];
  }
  
  for (CacheTransaction *transaction in transactionBatch.updateTransactions) {
    HomeTableViewCellObject *cellObject = [self.cellObjectBuilder buildCellObjectForToken:transaction.object];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:transaction.oldIndexPath.row inSection:0];
    [self.tableViewModel removeObjectAtIndexPath:oldIndexPath];
    [self.tableViewModel insertObject:cellObject atRow:transaction.updatedIndexPath.row inSection:0];
  }
  
  NSMutableArray *removeIndexPaths = [NSMutableArray array];
  for (CacheTransaction *transaction in transactionBatch.deleteTransactions) {
    NSIndexPath *removeIndexPath = [NSIndexPath indexPathForRow:transaction.oldIndexPath.row inSection:0];
    [removeIndexPaths addObject:removeIndexPath];
  }
  [removeIndexPaths sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"row" ascending:NO]]];
  for (NSIndexPath *indexPath in removeIndexPaths) {
    [self.tableViewModel removeObjectAtIndexPath:indexPath];
  }
  
  for (CacheTransaction *transaction in transactionBatch.moveTransactions) {
    HomeTableViewCellObject *cellObject = [self.cellObjectBuilder buildCellObjectForToken:transaction.object];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:transaction.oldIndexPath.row inSection:0];
    [self.tableViewModel removeObjectAtIndexPath:oldIndexPath];
    [self.tableViewModel insertObject:cellObject atRow:transaction.updatedIndexPath.row inSection:0];
  }
  [self.animator updateWithTransactionBatch:transactionBatch];

  if ([self.tableViewModel tableView:self.animator.tableView numberOfRowsInSection:0] == 0 && maximumCount == 0) {
    _empty = YES;
    [self.tableViewModel addObject:[self.cellObjectBuilder buildEmptyCellObject]];
    [self.animator reloadData];
  }
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [CellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.tableViewModel];
}

#pragma mark - DataDisplayManager methods

- (id<UITableViewDataSource>)dataSourceForTableView:(UITableView *)tableView {
  if (!self.tableViewModel) {
    [self updateTableViewModel];
  }
  return self.tableViewModel;
}

- (id<UITableViewDelegate>)delegateForTableView:(UITableView *)tableView withBaseDelegate:(id<UITableViewDelegate>)baseTableViewDelegate {
  if (!self.tableViewActions) {
    [self setupTableViewActions];
  }
  return [self.tableViewActions forwardingTo:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [self.delegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
  [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

#pragma mark - Private

- (void) updateTableViewModel {
  self.tableViewModel = [[NIMutableTableViewModel alloc] initWithDelegate:(id)[CellFactory class]];
  [self.tableViewModel insertSectionWithTitle:nil atIndex:0];
}

- (void)setupTableViewActions {
  self.tableViewActions = [[NITableViewActions alloc] initWithTarget:self];
}

@end
