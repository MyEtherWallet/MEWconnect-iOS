//
//  KeychainServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UICKeyChainStore;

#import "KeychainItemModel.h"

#import "KeychainServiceImplementation.h"

static NSString *const kKeychainServiceItemFormat     = @"%@_%d";
static NSString *const kKeychainServiceKeydataField   = @"keydata";
static NSString *const kKeychainServiceEntropyField   = @"entropy";

@implementation KeychainServiceImplementation

- (NSArray<KeychainItemModel *> *) obtainStoredItems {
  NSArray *keys = [self.keychainStore allKeys];
  NSMutableArray *itemModels = [[NSMutableArray alloc] initWithCapacity:[keys count]];
  for (NSString *key in keys) {
    NSArray *items = [key componentsSeparatedByString:@"_"];
    if ([items count] == 2) {
      NSString *publicAddress = [items firstObject];
      BlockchainNetworkType network = [[items lastObject] integerValue];
      NSDictionary *item = [self _obtainItemWithKey:key];
      BOOL backedUp = (item[kKeychainServiceEntropyField] == nil);
      KeychainItemModel *itemModel = [KeychainItemModel itemModelWithPublicAddress:publicAddress fromNetwork:network isBackedUp:backedUp];
      [itemModels addObject:itemModel];
    }
  }
  return [itemModels copy];
}

- (void) saveKeydata:(NSData *)keydata ofPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network {
  NSString *key = [NSString stringWithFormat:kKeychainServiceItemFormat, publicAddress, network];
  NSMutableDictionary *item = [[self _obtainItemWithKey:key] mutableCopy];
  item[kKeychainServiceKeydataField] = keydata;
  [self _storeItem:item withKey:key];
}

- (void) saveEntropy:(NSData *)entropyData ofPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network {
  NSString *key = [NSString stringWithFormat:kKeychainServiceItemFormat, publicAddress, network];
  NSMutableDictionary *item = [[self _obtainItemWithKey:key] mutableCopy];
  item[kKeychainServiceEntropyField] = entropyData;
  [self _storeItem:item withKey:key];
}

- (NSData *) obtainKeydataOfPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network {
  NSString *key = [NSString stringWithFormat:kKeychainServiceItemFormat, publicAddress, network];
  NSDictionary *item = [self _obtainItemWithKey:key];
  return item[kKeychainServiceKeydataField];
}

- (NSData *) obtainEntropyOfPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network {
  NSString *key = [NSString stringWithFormat:kKeychainServiceItemFormat, publicAddress, network];
  NSDictionary *item = [self _obtainItemWithKey:key];
  return item[kKeychainServiceEntropyField];
}

- (void) removeKeydataOfPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network {
  NSString *key = [NSString stringWithFormat:kKeychainServiceItemFormat, publicAddress, network];
  [self _removeItemWithKey:key];
}

- (void) removeEntropyOfPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network {
  NSString *key = [NSString stringWithFormat:kKeychainServiceItemFormat, publicAddress, network];
  NSMutableDictionary *item = [[self _obtainItemWithKey:key] mutableCopy];
  [item removeObjectForKey:kKeychainServiceEntropyField];
  [self _storeItem:item withKey:key];
}

#pragma mark - Private

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

- (void) _removeItemWithKey:(NSString *)key {
  [self.keychainStore removeItemForKey:key];
}

@end
