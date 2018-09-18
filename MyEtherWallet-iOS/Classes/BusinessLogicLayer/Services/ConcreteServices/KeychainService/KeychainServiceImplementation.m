//
//  KeychainServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UICKeyChainStore;

#import "KeychainItemModel.h"
#import "KeychainHistoryItemModel.h"

#import "KeychainServiceImplementation.h"

static NSString *const kKeychainServiceItemFormat           = @"%@_%d";
static NSString *const kKeychainServiceKeydataField         = @"keydata";
static NSString *const kKeychainServiceEntropyField         = @"entropy";
static NSString *const kKeychainServiceSimplexHistoryField  = @"history";

static NSString *const kKeychainServiceSimplexUserIdField   = @"userId";
static NSString *const kKeychainServiceSimplexDateField     = @"date";

static NSString *const kKeychainServiceFirstLaunchField     = @"firstLaunch";
static NSString *const kKeychainServiceRateAskedValue       = @"true";
static NSString *const kKeychainServiceRateAskedField       = @"com.myetherwallet.rater.rateasked";

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

- (void) saveSimplexUserId:(NSString *)userId ofPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network {
  NSString *key = [NSString stringWithFormat:kKeychainServiceItemFormat, publicAddress, network];
  NSMutableDictionary *item = [[self _obtainItemWithKey:key] mutableCopy];
  NSMutableArray *history = [item[kKeychainServiceSimplexHistoryField] mutableCopy];
  if (!history) {
    history = [[NSMutableArray alloc] initWithCapacity:1];
  }
  NSDictionary *historyItem = @{kKeychainServiceSimplexUserIdField: userId,
                                kKeychainServiceSimplexDateField: [NSDate date]};
  [history addObject:historyItem];
  item[kKeychainServiceSimplexHistoryField] = history;
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

- (NSArray<KeychainHistoryItemModel *> *) obtainSimplexHistoryOfPublicAddress:(NSString *)publicAddress fromNetwork:(BlockchainNetworkType)network {
  NSString *key = [NSString stringWithFormat:kKeychainServiceItemFormat, publicAddress, network];
  NSDictionary *item = [self _obtainItemWithKey:key];
  NSArray <NSDictionary *> *history = item[kKeychainServiceSimplexHistoryField];
  NSMutableArray <KeychainHistoryItemModel *> *historyItems = [[NSMutableArray alloc] initWithCapacity:[history count]];
  for (NSDictionary *historyItem in history) {
    NSString *userId = historyItem[kKeychainServiceSimplexUserIdField];
    NSDate *date = historyItem[kKeychainServiceSimplexDateField];
    KeychainHistoryItemModel *historyItemModel = [KeychainHistoryItemModel historyItemModelWithUserId:userId date:date];
    [historyItems addObject:historyItemModel];
  }
  return [historyItems copy];
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
