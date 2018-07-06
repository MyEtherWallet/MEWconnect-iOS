//
//  BlockchainNetworkService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@class NetworkModelObject;

@protocol BlockchainNetworkService <NSObject>
- (NetworkModelObject *) obtainActiveNetwork;
- (BOOL) selectNetwork:(BlockchainNetworkType)network;
@end
