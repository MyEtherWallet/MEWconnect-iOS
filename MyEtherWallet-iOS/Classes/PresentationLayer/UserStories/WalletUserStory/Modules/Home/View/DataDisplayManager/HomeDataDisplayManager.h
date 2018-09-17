//
//  HomeDataDisplayManager.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "DataDisplayManager.h"

@class CacheTransactionBatch;
@class HomeCellObjectBuilder;
@class HomePlainObject;
@class HomeTableViewAnimator;

@protocol HomeDataDisplayManagerProtocol <NSObject>
- (void) didTapCellWithObject:(HomePlainObject *)object;
- (void) scrollViewDidScroll:(UIScrollView *)scrollView;
- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
@end

@interface HomeDataDisplayManager : NSObject <DataDisplayManager, UITableViewDelegate>
@property (nonatomic, weak) id <HomeDataDisplayManagerProtocol> delegate;
@property (nonatomic, strong) HomeCellObjectBuilder *cellObjectBuilder;
@property (nonatomic, weak) HomeTableViewAnimator *animator;
- (void)configureDataDisplayManagerWithAnimator:(HomeTableViewAnimator *)animator;
- (void)updateDataDisplayManagerWithTransactionBatch:(CacheTransactionBatch *)transactionBatch maximumCount:(NSUInteger)maximumCount;
@end
