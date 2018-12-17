//
//  KeychainServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UICKeyChainStore;

#import "KeychainService+Protected.h"

#import "KeychainServiceSharedConstants.h"
#import "KeychainServiceConstantsV2.h"

#import "KeychainAccountModel.h"
#import "KeychainNetworkModel.h"
#import "KeychainHistoryItemModel.h"

#import "KeychainServiceImplementation.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "MasterTokenPlainObject.h"

@interface KeychainServiceImplementation () <KeychainServiceProtected>
@end

@implementation KeychainServiceImplementation

- (NSArray<KeychainAccountModel *> *) obtainStoredItems {
  NSArray *keys = [self.keychainStore allKeys];
  NSMutableArray *itemModels = [[NSMutableArray alloc] initWithCapacity:[keys count]];
  for (NSString *key in keys) {
    if ([key hasPrefix:kKeychainServiceV2ItemPrefix]) {
      NSArray <NSString *> *components = [key componentsSeparatedByString:@"_"];
      if ([components count] != 2) {
        continue;
      }
      NSString *uid = [components lastObject];
      
      NSString *itemKey = [self _keyForUID:uid];
      NSDictionary *item = [self _obtainItemWithKey:itemKey];
      NSMutableArray <NSString *> *networks = [[item allKeys] mutableCopy];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF beginsWith[c] %@ || SELF  beginsWith[c] %@)",
                                kKeychainServiceV2HistoryPrefix, kKeychainServiceBackupField];
      [networks filterUsingPredicate:predicate];
      [networks removeObject:kKeychainServiceEntropyField];
      
      NSMutableArray <KeychainNetworkModel *> *networkModels = [[NSMutableArray alloc] initWithCapacity:0];
      for (NSString *networkKey in networks) {
        NSArray <NSString *> *networkComponents = [networkKey componentsSeparatedByString:@"_"];
        NSString *address = [networkComponents firstObject];
        NSInteger chainID = [[networkComponents lastObject] integerValue];
        KeychainNetworkModel *networkModel = [KeychainNetworkModel itemModelWithAddress:address chainID:chainID];
        [networkModels addObject:networkModel];
      }
      
      BOOL backedUp = [item[kKeychainServiceBackupField] boolValue];
      KeychainAccountModel *accountModel = [KeychainAccountModel itemWithUID:uid backedUp:backedUp networks:[networkModels copy]];
      [itemModels addObject:accountModel];
    }
  }
  return [itemModels copy];
}

- (void) saveKeydata:(NSData *)keydata forAddress:(NSString *)address ofAccount:(AccountPlainObject *)account inChainID:(NSInteger)chainID {
  NSString *key = [self _keyForUID:account.uid];
  NSString *keydataKey = [self _keyForAddress:address chainID:chainID];
  @synchronized (self) {
    NSMutableDictionary *item = [[self _obtainItemWithKey:key] mutableCopy];
    item[keydataKey] = keydata;
    [self _storeItem:item withKey:key];
  }
}

- (void) saveEntropy:(NSData *)entropyData ofAccount:(AccountPlainObject *)account {
  NSString *key = [self _keyForUID:account.uid];
  @synchronized (self) {
    NSMutableDictionary *item = [[self _obtainItemWithKey:key] mutableCopy];
    item[kKeychainServiceEntropyField] = entropyData;
    [self _storeItem:item withKey:key];
  }
}

- (void) savePurchaseUserId:(NSString *)userId forMasterToken:(MasterTokenPlainObject *)token {
  NSString *key = [self _keyForUID:token.fromNetworkMaster.fromAccount.uid];
  @synchronized (self) {
    NSMutableDictionary *item = [[self _obtainItemWithKey:key] mutableCopy];
    NSString *historyKey = [self _historyKeyForAddress:token.address chainID:[token.fromNetworkMaster network]];
    NSMutableArray *history = [item[historyKey] mutableCopy];
    if (!history) {
      history = [[NSMutableArray alloc] initWithCapacity:1];
    }
    NSDictionary *historyItem = @{kKeychainServicePurchaseUserIdField: userId,
                                  kKeychainServicePurchaseDateField: [NSDate date]};
    [history addObject:historyItem];
    item[historyKey] = history;
    [self _storeItem:item withKey:key];
  }
}

- (void) saveBackupStatus:(BOOL)backup forAccount:(AccountPlainObject *)account {
  NSString *key = [self _keyForUID:account.uid];
  @synchronized (self) {
    NSMutableDictionary *item = [[self _obtainItemWithKey:key] mutableCopy];
    item[kKeychainServiceBackupField] = @(backup);
    [self _storeItem:item withKey:key];
  }
}

- (NSData *) obtainKeydataOfMasterToken:(MasterTokenPlainObject *)token ofAccount:(AccountPlainObject *)account inChainID:(NSInteger)chainID {
  NSString *key = [self _keyForUID:account.uid];
  NSDictionary *item = [self _obtainItemWithKey:key];
  NSString *keydataKey = [self _keyForAddress:token.address chainID:chainID];
  return item[keydataKey];
}

- (NSData *) obtainEntropyOfAccount:(AccountPlainObject *)account {
  NSString *key = [self _keyForUID:account.uid];
  NSDictionary *item = [self _obtainItemWithKey:key];
  return item[kKeychainServiceEntropyField];
}

- (NSArray <KeychainHistoryItemModel *> *) obtainPurchaseHistoryOfMasterToken:(MasterTokenPlainObject *)token {
  NSString *key = [self _keyForUID:token.fromNetworkMaster.fromAccount.uid];
  NSDictionary *item = nil;
  @synchronized (self) {
    item = [self _obtainItemWithKey:key];
  }
  NSString *historyKey = [self _historyKeyForAddress:token.address chainID:[token.fromNetworkMaster network]];
  NSArray <NSDictionary *> *history = item[historyKey];
  NSMutableArray <KeychainHistoryItemModel *> *historyItems = [[NSMutableArray alloc] initWithCapacity:[history count]];
  for (NSDictionary *historyItem in history) {
    NSString *userId = historyItem[kKeychainServicePurchaseUserIdField];
    NSDate *date = historyItem[kKeychainServicePurchaseDateField];
    KeychainHistoryItemModel *historyItemModel = [KeychainHistoryItemModel historyItemModelWithUserId:userId date:date];
    [historyItems addObject:historyItemModel];
  }
  
  return [historyItems copy];
}

- (BOOL)obtainBackupStatusForAccount:(AccountPlainObject *)account {
  NSString *key = [self _keyForUID:account.uid];
  NSMutableDictionary *item = [[self _obtainItemWithKey:key] mutableCopy];
  return [item[kKeychainServiceBackupField] boolValue];
}

- (void) removeDataOfAccount:(AccountPlainObject *)account {
  NSArray <NSString *> *keys = [self.keychainStore allKeys];
  for (NSString *key in keys) {
    if ([key hasSuffix:account.uid]) {
      [self _removeItemWithKey:key];
    }
  }
}

- (void) resetKeychain {
  NSArray <NSString *> *keys = [self.keychainStore allKeys];
  NSArray *ignoringKeys = @[kKeychainServiceRateAskedField, /*kKeychainServiceVersionField,*/ kKeychainServiceFirstLaunchField];
  for (NSString *key in keys) {
    if (![ignoringKeys containsObject:key]) {
      [self _removeItemWithKey:key];
    }
  }
}

- (void) saveFirstLaunchDate {
  if (![self.keychainStore stringForKey:kKeychainServiceFirstLaunchField]) {
    NSDate *date = [NSDate date];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [self.keychainStore setString:dateString forKey:kKeychainServiceFirstLaunchField];
  }
}

- (NSString *)obtainFirstLaunchDate {
  return [self.keychainStore stringForKey:kKeychainServiceFirstLaunchField];
}

- (void) rateDidAsked {
  [self.keychainStore setString:kKeychainServiceRateAskedValue forKey:kKeychainServiceRateAskedField];
}

- (BOOL) obtainRateStatus {
  return [self.keychainStore stringForKey:kKeychainServiceRateAskedField] != nil;
}

#pragma mark - Protected

#pragma mark - KeychainServiceProtected

- (NSString *) _keyForUID:(NSString *)uid {
  NSParameterAssert(uid);
  NSString *key = [NSString stringWithFormat:kKeychainServiceV2ItemFormat, uid];
  return key;
}

- (NSDictionary *) _obtainItemWithKey:(NSString *)key {
  NSData *itemData = [self.keychainStore dataForKey:key];
  if (itemData) {
    NSDictionary *item = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
    return item;
  }
  return @{};
}

- (void) _storeItem:(NSDictionary *)item withKey:(NSString *)key {
  NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
  [self.keychainStore setData:itemData forKey:key];
}

- (NSInteger) _obtainKeychainVersion {
  NSDictionary *item = [self _obtainItemWithKey:kKeychainServiceVersionField];
  NSNumber *version = item[kKeychainServiceCurrentKeychainVersionField];
  return MAX([version integerValue], 1);
}

- (void) _storeKeychainVersion:(NSInteger)version {
  NSMutableDictionary *item = [[self _obtainItemWithKey:kKeychainServiceVersionField] mutableCopy];
  item[kKeychainServiceCurrentKeychainVersionField] = @(version);
  [self _storeItem:item withKey:kKeychainServiceVersionField];
}

- (NSArray *) _obtainRawKeys {
  NSMutableArray <NSString *> *keys = [[self.keychainStore allKeys] mutableCopy];
  NSArray *ignoringKeys = @[kKeychainServiceRateAskedField, kKeychainServiceVersionField, kKeychainServiceFirstLaunchField];
  [keys removeObjectsInArray:ignoringKeys];
  return [keys copy];
}

- (void) _removeItemWithKey:(NSString *)key {
  NSError *error = nil;
  if (![self.keychainStore removeItemForKey:key error:&error]) {
    NSLog(@"Keychain error: %@", error);
  }
}

- (NSString *) _keyForAddress:(NSString *)address chainID:(NSInteger)chainID {
  NSString *key = [NSString stringWithFormat:kKeychainServiceV2KeyFormat, address, [@(chainID) stringValue]];
  return key;
}

- (NSString *) _historyKeyForAddress:(NSString *)address chainID:(NSInteger)chainID {
  NSString *key = [NSString stringWithFormat:kKeychainServiceV2HistoryKeyFormat, address, [@(chainID) stringValue]];
  return key;
}

@end
