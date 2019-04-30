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
#import "BlockchainNetworkTypesInfoProvider.h"

#import "CoreDataConfiguratorImplementation.h"

static NSString *const kCoreDataConfiguratorStructureValidation  = @"com.myetherwallet.coredata.validation";

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
  
  // Check structure
  
  if (![self.userDefaults boolForKey:kCoreDataConfiguratorStructureValidation]) {
    [rootSavingContext performBlockAndWait:^{
      NSArray <AccountModelObject *> *accountModels = [AccountModelObject MR_findAllInContext:rootSavingContext];
      NSArray <KeychainAccountModel *> *storedItems = [self.keychainService obtainStoredItems];
      
      void(^ClearCoreData)(NSManagedObjectContext *) = ^(NSManagedObjectContext *context) {
        NSArray <TokenModelObject *> *tokens = [TokenModelObject MR_findAllInContext:context];
        NSArray <AccountModelObject *> *accountModels = [AccountModelObject MR_findAllInContext:context];
        [context MR_deleteObjects:tokens];
        [context MR_deleteObjects:accountModels];
        if ([context hasChanges]) {
          [context MR_saveToPersistentStoreAndWait];
        }
      };
      if ([storedItems count] == 0) {
        ClearCoreData(rootSavingContext);
        return;
      }
      
      NSMutableSet *invalidAccounts = [[NSMutableSet alloc] initWithArray:accountModels];
      
      for (KeychainAccountModel *keychainAccount in storedItems) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.uid = %@", keychainAccount.uid];
        NSArray <AccountModelObject *> *filteredAccountModels = [accountModels filteredArrayUsingPredicate:predicate];
        if ([filteredAccountModels count] > 1) {
          ClearCoreData(rootSavingContext);
          return;
        }
        AccountModelObject *accountModelObject = [filteredAccountModels firstObject];
        if (accountModelObject) {
          [invalidAccounts removeObject:accountModelObject];
          
          NSMutableSet *invalidNetworks = [accountModelObject.networks mutableCopy];
          
          for (KeychainNetworkModel *keychainNetworkItem in keychainAccount.networks) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.master.address = %@", keychainNetworkItem.address];
            NSSet *networks = [accountModelObject.networks filteredSetUsingPredicate:predicate];
            if ([networks count] != 1) {
              ClearCoreData(rootSavingContext);
              return;
            }
            [invalidNetworks minusSet:networks];
          }
          
          if ([invalidNetworks count] > 0) {
            [rootSavingContext  MR_deleteObjects:invalidNetworks];
          }
        }
      }
      
      if ([invalidAccounts count] > 0) {
        [rootSavingContext MR_deleteObjects:invalidAccounts];
      }
      
      AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstInContext:rootSavingContext];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.chainID = %lld", BlockchainNetworkTypeEthereum];
      NetworkModelObject *networkModelObject = [[accountModelObject.networks filteredSetUsingPredicate:predicate] anyObject];
      if (!networkModelObject) {
        networkModelObject = [accountModelObject.networks anyObject];
      }
      
      accountModelObject.active = @YES;
      networkModelObject.active = @YES;
      
      if ([rootSavingContext hasChanges]) {
        [rootSavingContext MR_saveToPersistentStoreAndWait];
      }
    }];
    [self.userDefaults setBool:YES forKey:kCoreDataConfiguratorStructureValidation];
    [self.userDefaults synchronize];
  }
  
  // Restore structure if needed
  
  [rootSavingContext performBlockAndWait:^{
    NSArray <AccountModelObject *> *accountModels = [AccountModelObject MR_findAllInContext:rootSavingContext];
    NSArray <KeychainAccountModel *> *storedItems = [self.keychainService obtainStoredItems];
    if ([accountModels count] == 0 && [storedItems count] != 0) {
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
          masterTokenModelObject.name = [BlockchainNetworkTypesInfoProvider nameForNetworkType:keychainNetworkItem.chainID];
          masterTokenModelObject.symbol = [BlockchainNetworkTypesInfoProvider currencySymbolForNetworkType:keychainNetworkItem.chainID];
          
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
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.chainID = %lld", BlockchainNetworkTypeEthereum];
      NetworkModelObject *networkModelObject = [[accountModelObject.networks filteredSetUsingPredicate:predicate] anyObject];
      if (!networkModelObject) {
        networkModelObject = [accountModelObject.networks anyObject];
      }
      
      accountModelObject.active = @YES;
      networkModelObject.active = @YES;
    }
    //Clear ghost tokens
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromNetworkMaster == nil && SELF.fromNetwork == nil"];
    NSArray <MasterTokenModelObject *> *ghostMasterTokens = [MasterTokenModelObject MR_findAllWithPredicate:predicate inContext:rootSavingContext];
    if ([ghostMasterTokens count] > 0) {
      [rootSavingContext MR_deleteObjects:ghostMasterTokens];
    }
    
    predicate = [NSPredicate predicateWithFormat:@"SELF.fromNetwork == nil"];
    NSFetchRequest <TokenModelObject *> *request = [TokenModelObject MR_requestAllWithPredicate:predicate inContext:rootSavingContext];
    request.includesSubentities = NO;
    NSArray <TokenModelObject *> *ghostTokens = [request execute:nil];
    if ([ghostTokens count] > 0) {
      [rootSavingContext MR_deleteObjects:ghostTokens];
    }
    if ([rootSavingContext hasChanges]) {
      [rootSavingContext MR_saveToPersistentStoreAndWait];
    }
  }];
}

@end
