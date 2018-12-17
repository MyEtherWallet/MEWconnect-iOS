//
//  HomeInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@class MEWConnectResponse;
@class AccountPlainObject;
@class NetworkPlainObject;
@class MasterTokenPlainObject;

@protocol HomeInteractorInput <NSObject>
- (void) refreshMasterToken;
- (AccountPlainObject *) obtainAccount;
- (NetworkPlainObject *) obtainNetwork;
- (MasterTokenPlainObject *) obtainMasterToken;
- (void) configurate;
- (NSUInteger) obtainNumberOfTokens;
- (NSDecimalNumber *) obtainTotalPriceOfTokens;
- (void) reloadData;
- (void) refreshTokens;
- (void) searchTokensWithTerm:(NSString *)term;
- (void) disconnect;
- (BOOL) isConnected;
- (void) selectMainnetNetwork;
- (void) selectRopstenNetwork;
- (void) generateMissedKeysWithPassword:(NSString *)password;
- (void) transactionDidSigned;
- (void) requestRaterIfNeeded;
@end
