//
//  TokensService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AccountPlainObject;

typedef void(^TokensServiceCompletion)(NSError *error);

@protocol TokensService <NSObject>
- (void) updateTokenBalancesForAccount:(AccountPlainObject *)account withCompletion:(TokensServiceCompletion)completion;
- (NSUInteger) obtainNumberOfTokensForAccount:(AccountPlainObject *)account;
@end
