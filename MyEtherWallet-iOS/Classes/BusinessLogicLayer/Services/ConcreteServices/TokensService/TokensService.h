//
//  TokensService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenModelObject;

typedef void(^TokensServiceCompletion)(NSError *error);

@protocol TokensService <NSObject>
- (void) updateEthereumBalanceForAddress:(NSString *)address withCompletion:(TokensServiceCompletion)completion;
- (void) updateTokenBalancesForAddress:(NSString *)address withCompletion:(TokensServiceCompletion)completion;
- (NSArray <TokenModelObject *> *) obtainTokens;
- (NSUInteger) obtainNumberOfTokens;
- (TokenModelObject *) obtainEthereum;
- (void) clearTokens;
@end
