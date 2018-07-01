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
- (void) setupInitialStateWithNumberOfTokens:(NSUInteger)tokensCount;
- (void) updateWithAccount:(AccountPlainObject *)account;
- (void) updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch;
- (void) updateWithTokensCount:(NSUInteger)tokensCount;
- (void) updateWithConnectionStatus:(BOOL)connected animated:(BOOL)animated;
@end
