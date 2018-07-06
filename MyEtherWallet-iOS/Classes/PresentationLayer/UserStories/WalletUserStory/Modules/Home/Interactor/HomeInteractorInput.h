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
@class TokenPlainObject;

@protocol HomeInteractorInput <NSObject>
- (void) refreshAccount;
- (AccountPlainObject *) obtainAccount;
- (void) configurate;
- (NSUInteger) obtainNumberOfTokens;
- (NSDecimalNumber *) obtainTotalPriceOfTokens;
- (void) reloadData;
- (void) subscribe;
- (void) unsubscribe;
- (void) searchTokensWithTerm:(NSString *)term;
- (void) disconnect;
- (BOOL) isConnected;
@end
