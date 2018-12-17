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

#import "UIImage+Color.h"

@implementation BuyEtherHistoryViewController

#pragma mark - LifeCycle

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
  [super viewWillDisappear:animated];
}

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
