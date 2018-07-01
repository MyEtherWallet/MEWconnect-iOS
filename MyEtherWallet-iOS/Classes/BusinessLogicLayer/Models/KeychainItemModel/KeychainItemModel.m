//
//  KeychainItemModel.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "KeychainItemModel.h"

@interface KeychainItemModel ()
@property (nonatomic) BlockchainNetworkType network;
@property (nonatomic, strong) NSString *publicAddress;
@property (nonatomic) BOOL backedUp;
@end

@implementation KeychainItemModel

+ (instancetype) itemModelWithPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network isBackedUp:(BOOL)backedUp {
  KeychainItemModel *itemModel = [[[self class] alloc] init];
  itemModel.publicAddress = publicAddress;
  itemModel.network = network;
  itemModel.backedUp = backedUp;
  return itemModel;
}

@end
