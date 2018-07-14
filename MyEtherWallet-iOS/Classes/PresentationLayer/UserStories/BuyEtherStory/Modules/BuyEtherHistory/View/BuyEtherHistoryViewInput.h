//
//  BuyEtherHistoryViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class CacheTransactionBatch;

@protocol BuyEtherHistoryViewInput <NSObject>
- (void) setupInitialState;
- (void) updateWithCacheTransaction:(CacheTransactionBatch *)cacheTransactionBatch;

@end
