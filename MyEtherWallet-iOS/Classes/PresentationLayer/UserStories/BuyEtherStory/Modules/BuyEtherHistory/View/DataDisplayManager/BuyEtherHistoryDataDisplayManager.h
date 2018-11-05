//
//  BuyEtherHistoryDataDisplayManager.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 06/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "DataDisplayManager.h"

@class CacheTransactionBatch;
@class BuyEtherHistoryCellObjectBuilder;
@class BuyEtherHistoryTableViewAnimator;

@interface BuyEtherHistoryDataDisplayManager : NSObject <DataDisplayManager, UITableViewDelegate>
@property (nonatomic, strong) BuyEtherHistoryCellObjectBuilder *cellObjectBuilder;
@property (nonatomic, weak) BuyEtherHistoryTableViewAnimator *animator;
- (void)configureDataDisplayManagerWithAnimator:(BuyEtherHistoryTableViewAnimator *)animator;
- (void)updateDataDisplayManagerWithTransactionBatch:(CacheTransactionBatch *)transactionBatch;
@end
