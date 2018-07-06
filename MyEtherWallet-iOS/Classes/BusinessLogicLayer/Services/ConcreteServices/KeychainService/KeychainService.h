//
//  KeychainService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class KeychainItemModel;

#import "BlockchainNetworkTypes.h"

@protocol KeychainService <NSObject>
/**
 Obtaining all public addresses of stored private addresses
 
 @returns Array of @b KeychainItemModel
 */
- (NSArray <KeychainItemModel *> *) obtainStoredItems;

- (void) saveKeydata:(NSData *)keydata ofPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network;
- (void) saveEntropy:(NSData *)entropyData ofPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network;
- (NSData *) obtainKeydataOfPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network;
- (NSData *) obtainEntropyOfPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network;
- (void) removeKeydataOfPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network;
- (void) removeEntropyOfPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network;
@end
