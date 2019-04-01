//
//  KeychainService+Protected.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BlockchainNetworkTypes.h"

@class AccountPlainObject;

@protocol KeychainServiceProtected <NSObject>
- (NSString *) _keyForUID:(NSString *)uid;
- (NSString *) _keyForAddress:(NSString *)address chainID:(BlockchainNetworkType)chainID;
- (NSString *) _historyKeyForAddress:(NSString *)address chainID:(BlockchainNetworkType)chainID;
- (NSDictionary *) _obtainItemWithKey:(NSString *)key;
- (void) _storeItem:(NSDictionary *)item withKey:(NSString *)key;
- (void) _removeItemWithKey:(NSString *)key;
- (NSInteger) _obtainKeychainVersion;
- (void) _storeKeychainVersion:(NSInteger)version;
- (NSArray *) _obtainRawKeys;
@end
