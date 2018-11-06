//
//  BlockchainNetworkService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@class AccountPlainObject;
@class NetworkPlainObject;
@class NetworkModelObject;

@protocol BlockchainNetworkService <NSObject>
- (NetworkModelObject *) obtainActiveNetwork;
- (void) selectNetwork:(NetworkPlainObject *)network inAccount:(AccountPlainObject *)account;
- (NetworkModelObject *) createNetworkWithChainID:(NSInteger)chainID inAccount:(AccountPlainObject *)account;
@end
