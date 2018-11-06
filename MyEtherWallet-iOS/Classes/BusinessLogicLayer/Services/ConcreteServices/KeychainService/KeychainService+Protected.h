//
//  KeychainService+Protected.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@class AccountPlainObject;

@protocol KeychainServiceProtected <NSObject>
- (NSString *) _keyForUID:(NSString *)uid;
- (NSString *) _keyForAddress:(NSString *)address chainID:(NSInteger)chainID;
- (NSString *) _historyKeyForAddress:(NSString *)address chainID:(NSInteger)chainID;
- (NSDictionary *) _obtainItemWithKey:(NSString *)key;
- (void) _storeItem:(NSDictionary *)item withKey:(NSString *)key;
- (void) _removeItemWithKey:(NSString *)key;
- (NSInteger) _obtainKeychainVersion;
- (void) _storeKeychainVersion:(NSInteger)version;
- (NSArray *) _obtainRawKeys;
@end
