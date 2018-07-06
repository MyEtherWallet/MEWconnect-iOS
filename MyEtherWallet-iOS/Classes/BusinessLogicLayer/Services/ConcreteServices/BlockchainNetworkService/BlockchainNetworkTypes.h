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

typedef NS_ENUM(short, BlockchainNetworkType) {
  BlockchainNetworkTypeMainnet  = 1,
  BlockchainNetworkTypeRopsten  = 3,
};

NS_INLINE NSString *NSStringCurrencySymbolFromBlockchainNetworkType(BlockchainNetworkType type) {
  switch (type) {
    case BlockchainNetworkTypeRopsten: {
      return @"ROPSTEN ETH";
      break;
    }
    case BlockchainNetworkTypeMainnet:
    default: {
      return @"ETH";
      break;
    }
  }
}

#endif /* BlockchainNetworkTypes_h */
