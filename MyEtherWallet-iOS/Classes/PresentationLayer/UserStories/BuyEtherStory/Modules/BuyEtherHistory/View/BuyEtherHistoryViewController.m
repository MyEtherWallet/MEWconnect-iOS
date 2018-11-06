//
//  BuyEtherHistoryViewController.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryViewController.h"

#import "BuyEtherHistoryViewOutput.h"

#import "BuyEtherHistoryTableViewAnimator.h"
#import "BuyEtherHistoryDataDisplayManager.h"

@implementation BuyEtherHistoryViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.output didTriggerViewReadyEvent];
}

#pragma mark - BuyEtherHistoryViewInput

- (void) setupInitialState {
  self.tableView.dataSource = [self.dataDisplayManager dataSourceForTableView:self.tableView];
  self.tableView.delegate = [self.dataDisplayManager delegateForTableView:self.tableView
                                                         withBaseDelegate:self.dataDisplayManager];
  self.tableViewAnimator.tableView = self.tableView;
  [self.dataDisplayManager configureDataDisplayManagerWithAnimator:self.tableViewAnimator];
  [self.dataDisplayManager updateDataDisplayManagerWithTransactionBatch:nil];
}

- (void) updateWithCacheTransaction:(CacheTransactionBatch *)cacheTransactionBatch {
  [self.dataDisplayManager updateDataDisplayManagerWithTransactionBatch:cacheTransactionBatch];
}

@end
