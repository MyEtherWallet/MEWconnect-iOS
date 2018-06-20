//
//  HomeViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CacheTransactionBatch;

@class TokenPlainObject;

@protocol HomeViewInput <NSObject>
- (void) setupInitialStateWithNumberOfTokens:(NSUInteger)tokensCount;
- (void) updateWithAddress:(NSString *)address;
- (void) updateWithTransactionBatch:(CacheTransactionBatch *)transactionBatch;
- (void) updateBackupStatus:(BOOL)backedUp;
- (void) updateWithTokensCount:(NSUInteger)tokensCount;
- (void) updateWithConnectionStatus:(BOOL)connected animated:(BOOL)animated;
- (void) updateEthereumBalance:(TokenPlainObject *)ethereum;
- (void) updateTitle:(NSString *)title;
@end
