//
//  CoreDataConfiguratorImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;

#import "ApplicationConstants.h"

#import "Ponsomizer.h"

#import "KeychainService.h"
#import "KeychainAccountModel.h"
#import "KeychainNetworkModel.h"
#import "KeychainHistoryItemModel.h"

#import "AccountModelObject.h"
#import "NetworkModelObject.h"
#import "MasterTokenModelObject.h"
#import "PurchaseHistoryModelObject.h"

#import "BlockchainNetworkTypes.h"

#import "CoreDataConfiguratorImplementation.h"

@implementation CoreDataConfiguratorImplementation

#pragma mark - Public

- (void) setupCoreDataStack {
  if ([self shouldMigrateCoreData]) {
    [self migrateStore];
  } else {
    NSURL *directory = [self.fileManager containerURLForSecurityApplicationGroupIdentifier:kAppGroupIdentifier];
    NSURL *storeURL = [directory URLByAppendingPathComponent:kCoreDataName];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:storeURL];
    NSError *error = nil;
    if (![storeURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error]) {
      DDLogError(@"CoreData configurator: %@", [error localizedDescription]);
    }
  }
  [self _restoreCoreDataStructure];
}

- (BOOL)shouldMigrateCoreData {
  NSString *oldStoreName = [MagicalRecord defaultStoreName];
  return [[NSFileManager defaultManager] fileExistsAtPath:oldStoreName];
}

- (void)migrateStore {
  NSString *oldStoreName = [MagicalRecord defaultStoreName];
  NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:oldStoreName];
  // grab the current store
  NSPersistentStore *currentStore = coordinator.persistentStores.lastObject;
  // create a new URL
  NSURL *directory = [self.fileManager containerURLForSecurityApplicationGroupIdentifier:kAppGroupIdentifier];
  NSURL *newStoreURL = [directory URLByAppendingPathComponent:kCoreDataName];
  
  NSDictionary *storeOptions = @{NSPersistentStoreFileProtectionKey: NSFileProtectionComplete};
  // migrate current store to new URL
  [coordinator migratePersistentStore:currentStore
                                toURL:newStoreURL
                              options:storeOptions
                             withType:NSSQLiteStoreType
                                error:nil];
  [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:newStoreURL];
}

#pragma mark - Private

- (void) _restoreCoreDataStructure {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlockAndWait:^{
    NSArray <AccountModelObject *> *accountModels = [AccountModelObject MR_findAllInContext:rootSavingContext];
    if ([accountModels count] == 0) {
      NSArray <KeychainAccountModel *> *storedItems = [self.keychainService obtainStoredItems];
      if ([storedItems count] == 0) {
        return;
      }
      
      for (KeychainAccountModel *keychainItem in storedItems) {
        AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstOrCreateByAttribute:NSStringFromSelector(@selector(uid)) withValue:keychainItem.uid inContext:rootSavingContext];
        accountModelObject.backedUp = @(keychainItem.backedUp);
        accountModelObject.name = @"Account";
        
        for (KeychainNetworkModel *keychainNetworkItem in keychainItem.networks) {
          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.master.address = %@", keychainNetworkItem.address];
          NSSet <NetworkModelObject *> *networks = [accountModelObject.networks filteredSetUsingPredicate:predicate];
          if ([networks count] > 0) {
            continue;
          }
          
          NetworkModelObject *networkModelObject = [NetworkModelObject MR_createEntityInContext:rootSavingContext];
          networkModelObject.chainID = @(keychainNetworkItem.chainID);
          
          MasterTokenModelObject *masterTokenModelObject = [MasterTokenModelObject MR_createEntityInContext:rootSavingContext];
          masterTokenModelObject.address = keychainNetworkItem.address;
          masterTokenModelObject.name = NSStringNameFromBlockchainNetworkType(keychainNetworkItem.chainID);
          masterTokenModelObject.symbol = NSStringCurrencySymbolFromBlockchainNetworkType(keychainNetworkItem.chainID);
          
          networkModelObject.master = masterTokenModelObject;
          [accountModelObject addNetworksObject:networkModelObject];
          
          NSArray *ignoringProperties = @[NSStringFromSelector(@selector(purchaseHistory)),
                                          NSStringFromSelector(@selector(price)),
                                          NSStringFromSelector(@selector(tokens)),
                                          NSStringFromSelector(@selector(networks))];
          MasterTokenPlainObject *masterToken = [self.ponsomizer convertObject:masterTokenModelObject ignoringProperties:ignoringProperties];
          
          NSArray <KeychainHistoryItemModel *> *purchaseHistory = [self.keychainService obtainPurchaseHistoryOfMasterToken:masterToken];
          for (KeychainHistoryItemModel *purchaseHistoryItem in purchaseHistory) {
            PurchaseHistoryModelObject *historyModelObject = [PurchaseHistoryModelObject MR_createEntityInContext:rootSavingContext];
            historyModelObject.date = purchaseHistoryItem.date;
            historyModelObject.userId = purchaseHistoryItem.userId;
            [masterTokenModelObject addPurchaseHistoryObject:historyModelObject];
          }

        }
      }
      
      AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstInContext:rootSavingContext];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.chainID = %d", BlockchainNetworkTypeMainnet];
      NetworkModelObject *networkModelObject = [[accountModelObject.networks filteredSetUsingPredicate:predicate] anyObject];
      if (!networkModelObject) {
        networkModelObject = [accountModelObject.networks anyObject];
      }
      
      accountModelObject.active = @YES;
      networkModelObject.active = @YES;
      
      if ([rootSavingContext hasChanges]) {
        [rootSavingContext MR_saveToPersistentStoreAndWait];
      }
    }
  }];
}

@end
