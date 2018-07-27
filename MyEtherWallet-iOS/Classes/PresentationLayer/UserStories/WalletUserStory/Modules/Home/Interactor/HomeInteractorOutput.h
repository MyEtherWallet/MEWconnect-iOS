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
@class AccountPlainObject;

@protocol HomeInteractorOutput <NSObject>
- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command;
- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command account:(AccountPlainObject *)account;
- (void) didProcessCacheTransaction:(CacheTransactionBatch *)transactionBatch;
- (void) didUpdateTokens;
- (void) didUpdateEthereumBalance;
- (void) didUpdateTokensBalance;
- (void) mewConnectionStatusChanged;
- (void) tokensDidStartUpdating;
- (void) tokensDidEndUpdating;
- (void) networkDidChangedWithAccount;
- (void) networkDidChangedWithoutAccount;
@end
