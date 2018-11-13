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
@class MasterTokenPlainObject;
@class AccountPlainObject;

@protocol HomeInteractorOutput <NSObject>
- (void) openMessageSignerWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken;
- (void) openTransactionSignerWithMessage:(MEWConnectCommand *)command masterToken:(MasterTokenPlainObject *)masterToken;
- (void) didProcessCacheTransaction:(CacheTransactionBatch *)transactionBatch;
- (void) didUpdateTokens;
- (void) didUpdateEthereumBalance;
- (void) didUpdateTokensBalance;
- (void) mewConnectionStatusChanged;
- (void) balancesDidStartUpdating;
- (void) balancesDidEndUpdating;
- (void) networkDidChanged;
- (void) internetConnectionIsReachable;
- (void) internetConnectionIsUnreachable;
- (void) passwordIsNeededWithAccount:(AccountPlainObject *)account;
- (void) seedIsNeededWithAccount:(AccountPlainObject *)account password:(NSString *)password;
@end
