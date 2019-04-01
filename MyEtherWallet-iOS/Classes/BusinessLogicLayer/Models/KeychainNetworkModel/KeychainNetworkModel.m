//
//  KeychainNetworkModel.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "KeychainNetworkModel.h"

@interface KeychainNetworkModel ()
@property (nonatomic, strong) NSString *address;
@property (nonatomic) BlockchainNetworkType chainID;
@end

@implementation KeychainNetworkModel

+ (instancetype) itemModelWithAddress:(NSString *)address chainID:(BlockchainNetworkType)chainID {
  KeychainNetworkModel *itemModel = [[[self class] alloc] init];
  itemModel.address = address;
  itemModel.chainID = chainID;
  return itemModel;
}

@end
