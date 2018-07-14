//
//  CoreDataConfiguratorImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;

#import "ApplicationConstants.h"

#import "KeychainService.h"
#import "KeychainItemModel.h"
#import "KeychainHistoryItemModel.h"

#import "NetworkModelObject.h"
#import "AccountModelObject.h"
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
    NSArray *networkModels = [NetworkModelObject MR_findAllInContext:rootSavingContext];
    if ([networkModels count] == 0) {
      NSArray <KeychainItemModel *> *storedItems = [self.keychainService obtainStoredItems];
      
      for (KeychainItemModel *keychainItem in storedItems) {
        NetworkModelObject *networkModelObject = [NetworkModelObject MR_findFirstOrCreateByAttribute:NSStringFromSelector(@selector(chainID)) withValue:@(keychainItem.network) inContext:rootSavingContext];
        AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstOrCreateByAttribute:NSStringFromSelector(@selector(publicAddress)) withValue:keychainItem.publicAddress inContext:rootSavingContext];
        accountModelObject.backedUp = @(keychainItem.backedUp);
        [networkModelObject addAccountsObject:accountModelObject];
        
        NSArray <KeychainHistoryItemModel *> *purchaseHistory = [self.keychainService obtainSimplexHistoryOfPublicAddress:keychainItem.publicAddress fromNetwork:keychainItem.network];
        for (KeychainHistoryItemModel *purchaseHistoryItem in purchaseHistory) {
          PurchaseHistoryModelObject *historyModelObject = [PurchaseHistoryModelObject MR_createEntityInContext:rootSavingContext];
          historyModelObject.date = purchaseHistoryItem.date;
          historyModelObject.userId = purchaseHistoryItem.userId;
          [accountModelObject addPurchaseHistoryObject:historyModelObject];
        }
      }
      NSArray <NetworkModelObject *> *allNetworks = [NetworkModelObject MR_findAllInContext:rootSavingContext];
      for (NetworkModelObject *network in allNetworks) {
        ((AccountModelObject *)[network.accounts firstObject]).active = @YES;
      }
      NetworkModelObject *mainnetModelObject = [NetworkModelObject MR_findFirstOrCreateByAttribute:NSStringFromSelector(@selector(chainID)) withValue:@(BlockchainNetworkTypeMainnet) inContext:rootSavingContext];
      mainnetModelObject.active = @YES;
      [rootSavingContext MR_saveToPersistentStoreAndWait];
    }
  }];
}

@end
