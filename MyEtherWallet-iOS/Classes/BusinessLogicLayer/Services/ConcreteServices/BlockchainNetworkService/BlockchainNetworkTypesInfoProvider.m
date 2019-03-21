//
//  BlockchainNetworkTypesInfoProvider.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/20/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "BlockchainNetworkTypesInfoProvider.h"

static NSDictionary *BlockchainNetworkInfoCurrencySymbols = nil;
static NSDictionary *BlockchainNetworkInfoNames = nil;

@implementation BlockchainNetworkTypesInfoProvider
+ (void) load {
  [super load];
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    BlockchainNetworkInfoCurrencySymbols = @{@(BlockchainNetworkTypeEthereum):          @"ETH",
                                             @(BlockchainNetworkTypeExpanse):           @"EXP",
                                             @(BlockchainNetworkTypeRopsten):           @"ROPSTEN ETH",
                                             @(BlockchainNetworkTypeRinkeby):           @"RIN",
                                             @(BlockchainNetworkTypeUbiq):              @"UBQ",
                                             @(BlockchainNetworkTypeEOSClassic):        @"EOSC",
                                             @(BlockchainNetworkTypeEthereumSocial):    @"ETSC",
                                             @(BlockchainNetworkTypeKovan):             @"KOV",
                                             @(BlockchainNetworkTypeGoChain):           @"GO",
                                             @(BlockchainNetworkTypeEthereumClassic):   @"ETC",
                                             @(BlockchainNetworkTypeEllaism):           @"ELLA",
                                             @(BlockchainNetworkTypeProofOfAuthority):  @"POA",
                                             @(BlockchainNetworkTypeCallisto):          @"CLO",
                                             @(BlockchainNetworkTypeEtherGem):          @"EGEM",
                                             @(BlockchainNetworkTypeEtherSocial):       @"ESN",
                                             @(BlockchainNetworkTypeTomoCoin):          @"TOMO",
                                             @(BlockchainNetworkTypeAkroma):            @"AKA",
                                             @(BlockchainNetworkTypeEther1):            @"ETHO",
                                             @(BlockchainNetworkTypeMusicCoin):         @"MUSIC",
                                             @(BlockchainNetworkTypePirl):              @"PIRL"};
    BlockchainNetworkInfoNames = @{@(BlockchainNetworkTypeEthereum):          @"Ethereum",
                                   @(BlockchainNetworkTypeExpanse):           @"Expanse",
                                   @(BlockchainNetworkTypeRopsten):           @"Ethereum Ropsten",
                                   @(BlockchainNetworkTypeRinkeby):           @"Rinkeby",
                                   @(BlockchainNetworkTypeUbiq):              @"Ubiq",
                                   @(BlockchainNetworkTypeEOSClassic):        @"EOS-Classic",
                                   @(BlockchainNetworkTypeEthereumSocial):    @"EthereumSocial",
                                   @(BlockchainNetworkTypeKovan):             @"Kovan",
                                   @(BlockchainNetworkTypeGoChain):           @"GoChain",
                                   @(BlockchainNetworkTypeEthereumClassic):   @"Ethereum Classic",
                                   @(BlockchainNetworkTypeEllaism):           @"Ellaism",
                                   @(BlockchainNetworkTypeProofOfAuthority):  @"Proof of Authority",
                                   @(BlockchainNetworkTypeCallisto):          @"Callisto",
                                   @(BlockchainNetworkTypeEtherGem):          @"EtherGem",
                                   @(BlockchainNetworkTypeEtherSocial):       @"EtherSocial",
                                   @(BlockchainNetworkTypeTomoCoin):          @"Tomo Coin",
                                   @(BlockchainNetworkTypeAkroma):            @"Akroma",
                                   @(BlockchainNetworkTypeEther1):            @"Ether1",
                                   @(BlockchainNetworkTypeMusicCoin):         @"Music Coin",
                                   @(BlockchainNetworkTypePirl):              @"Pirl"};
  });
}

+ (NSString *) currencySymbolForNetworkType:(BlockchainNetworkType)type {
  return BlockchainNetworkInfoCurrencySymbols[@(type)] ?: @"Unknown Token";
}

+ (NSString *) nameForNetworkType:(BlockchainNetworkType)type {
  return BlockchainNetworkInfoNames[@(type)] ?: @"Unknown Network";
}

+ (NSString *) stringFromNetworkType:(BlockchainNetworkType)type {
  switch (type) {
    case BlockchainNetworkTypeEthereum: {
      return @"Mainnet";
      break;
    }
    case BlockchainNetworkTypeRopsten: {
      return @"Ropsten";
      break;
    }
    default:
      break;
  }
  return @"";
}

@end
