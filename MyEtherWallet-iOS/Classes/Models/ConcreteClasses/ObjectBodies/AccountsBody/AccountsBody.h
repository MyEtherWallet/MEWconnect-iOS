//
//  AccountsBody.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 30/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@interface AccountsBody : NSObject
@property (nonatomic, strong) NSString  * address;
@property (nonatomic) BlockchainNetworkType network;
@end
