//
//  KeychainNetworkModel.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

#import "BlockchainNetworkTypes.h"

@interface KeychainNetworkModel : NSObject
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, readonly) NSInteger chainID;
+ (instancetype) itemModelWithAddress:(NSString *)address chainID:(NSInteger)chainID;
@end
