//
//  HomeViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CacheTransactionBatch;

@class MasterTokenPlainObject;
@class TokenPlainObject;

@protocol HomeViewInput <NSObject>
- (void) setupInitialStateWithNumberOfTokens:(NSUInteger)tokensCount totalPrice:(NSDecimalNumber *)totalPrice;
- (void) updateWithMasterToken:(MasterTokenPlainObject *)masterToken;
- (void) updateBalanceWithMasterToken:(MasterTokenPlainObject *)masterToken;
- (void) updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch;
- (void) updateWithTokensCount:(NSUInteger)tokensCount withTotalPrice:(NSDecimalNumber *)totalPrice;
- (void) startAnimatingRefreshing;
- (void) stopAnimatingRefreshing;
- (void) presentNetworkSelection;
- (void) updateStatusWithInternetConnection:(BOOL)internetConnection mewConnectConnection:(BOOL)mewConnectConnection animated:(BOOL)animated;
@end
