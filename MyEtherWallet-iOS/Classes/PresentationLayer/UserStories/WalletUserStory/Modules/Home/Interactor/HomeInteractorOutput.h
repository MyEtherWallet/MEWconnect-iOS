//
//  HomeInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class MEWConnectCommand;
@class CacheTransactionBatch;

@protocol HomeInteractorOutput <NSObject>
- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command;
- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command;
- (void) didProcessCacheTransaction:(CacheTransactionBatch *)transactionBatch;
- (void) didUpdateTokens;
- (void) didUpdateEthereumBalance;
- (void) mewConnectionStatusChanged;
@end
