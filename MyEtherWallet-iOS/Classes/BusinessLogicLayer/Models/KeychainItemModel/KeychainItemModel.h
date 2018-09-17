//
//  KeychainItemModel.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@interface KeychainItemModel : NSObject
@property (nonatomic, readonly) BlockchainNetworkType network;
@property (nonatomic, strong, readonly) NSString *publicAddress;
@property (nonatomic, readonly) BOOL backedUp;
+ (instancetype) itemModelWithPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network isBackedUp:(BOOL)backedUp;
@end
