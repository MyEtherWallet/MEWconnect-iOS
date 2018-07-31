//
//  HomeViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CacheTransactionBatch;

@class AccountPlainObject;
@class TokenPlainObject;

@protocol HomeViewInput <NSObject>
- (void) setupInitialStateWithNumberOfTokens:(NSUInteger)tokensCount totalPrice:(NSDecimalNumber *)totalPrice;
- (void) updateWithAccount:(AccountPlainObject *)account;
- (void) updateEthereumBalanceWithAccount:(AccountPlainObject *)account;
- (void) updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch;
- (void) updateWithTokensCount:(NSUInteger)tokensCount withTotalPrice:(NSDecimalNumber *)totalPrice;
- (void) updateWithConnectionStatus:(BOOL)connected animated:(BOOL)animated;
- (void) presentShareWithItems:(NSArray *)items;
- (void) startAnimatingTokensRefreshing;
- (void) stopAnimatingTokensRefreshing;
- (void) presentNetworkSelection;
- (void) showInternetConnection;
- (void) showNoInternetConnection;
@end
