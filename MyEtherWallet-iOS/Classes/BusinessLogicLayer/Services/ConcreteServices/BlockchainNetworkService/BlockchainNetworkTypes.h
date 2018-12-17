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

NS_INLINE NSString *NSStringNameFromBlockchainNetworkType(BlockchainNetworkType type) {
  switch (type) {
    case BlockchainNetworkTypeRopsten: {
      return @"Ethereum Ropsten";
      break;
    }
    case BlockchainNetworkTypeMainnet:
    default: {
      return @"Ethereum";
      break;
    }
  }
}

NS_INLINE NSString *NSStringFromBlockchainNetworkType(BlockchainNetworkType type) {
  switch (type) {
    case BlockchainNetworkTypeMainnet: {
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

#endif /* BlockchainNetworkTypes_h */
