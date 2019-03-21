//
//  BlockchainNetworkTypes.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#ifndef BlockchainNetworkTypes_h
#define BlockchainNetworkTypes_h

@import Foundation;

typedef NS_ENUM(NSInteger, BlockchainNetworkType) {
  BlockchainNetworkTypeEthereum         = 1,
  BlockchainNetworkTypeExpanse          = 2,
  BlockchainNetworkTypeRopsten          = 3,
  BlockchainNetworkTypeRinkeby          = 4,
  BlockchainNetworkTypeUbiq             = 8,
  BlockchainNetworkTypeEOSClassic       = 20,
  BlockchainNetworkTypeEthereumSocial   = 28,
  BlockchainNetworkTypeKovan            = 42,
  BlockchainNetworkTypeGoChain          = 60,
  BlockchainNetworkTypeEthereumClassic  = 61,
  BlockchainNetworkTypeEllaism          = 64,
  BlockchainNetworkTypeProofOfAuthority = 99,
  BlockchainNetworkTypeCallisto         = 820,
  BlockchainNetworkTypeEtherGem         = 1987,
  BlockchainNetworkTypeEtherSocial      = 31102,
  BlockchainNetworkTypeTomoCoin         = 40686,
  BlockchainNetworkTypeAkroma           = 200625,
  BlockchainNetworkTypeEther1           = 1313114,
  BlockchainNetworkTypeMusicCoin        = 7762959,
  BlockchainNetworkTypePirl             = 3125659152,
};

#endif /* BlockchainNetworkTypes_h */
