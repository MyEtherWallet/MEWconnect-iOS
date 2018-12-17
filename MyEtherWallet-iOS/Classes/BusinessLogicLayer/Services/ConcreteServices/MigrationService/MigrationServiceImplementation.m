//
//  MigrationServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import CoreData;

#import "MigrationServiceImplementation.h"

#import "MigrationManager.h"

#import "ApplicationConstants.h"

#import "KeychainService.h"
#import "KeychainService+Protected.h"

#import "KeychainServiceSharedConstants.h"
#import "KeychainServiceConstantsV1.h"
#import "KeychainServiceConstantsV2.h"

#import "AccountModelObject.h"
#import "NetworkModelObject.h"
#import "MasterTokenModelObject.h"

#import "BlockchainNetworkTypes.h"

static NSString *const kMigrationServiceMomFilename   = @"MEWconnect";
static NSString *const kMigrationServiceMomdExtension = @"momd";
static NSString *const kMigrationServiceMomExtension  = @"mom";

@interface MigrationServiceImplementation () <MigrationManagerDelegate>
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation MigrationServiceImplementation

- (BOOL) isMigrationNeeded {
  NSError *error = nil;
  
  // Check if we need to migrate
  NSDictionary *sourceMetadata = [self _sourceMetadata:&error];
  BOOL isMigrationNeeded = NO;
  
  if (sourceMetadata != nil) {
    NSManagedObjectModel *destinationModel = self.managedObjectModel;
    // Migration is needed if destinationModel is NOT compatible
    isMigrationNeeded = ![destinationModel isConfiguration:nil
                               compatibleWithStoreMetadata:sourceMetadata];
  }
  NSLog(@"isMigrationNeeded: %d", isMigrationNeeded);
  return isMigrationNeeded;
}

- (BOOL) migrate:(NSError **)error {
  // Enable migrations to run even while user exits app
  __block UIBackgroundTaskIdentifier bgTask;
  bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
  }];
  
  BOOL migrated = [self.migrationManager progressivelyMigrateURL:[self _sourceStoreURL]
                                                          ofType:[self _sourceStoreType]
                                                         toModel:[self managedObjectModel]
                                                           error:error];
#if DEBUG
  if (migrated) {
    NSLog(@"migration complete");
  }
#endif
  
  // Mark it as invalid
  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
  bgTask = UIBackgroundTaskInvalid;
  return migrated;
}

#pragma mark - Private

- (NSDictionary *) _sourceMetadata:(NSError **)error {
  return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:[self _sourceStoreType]
                                                                    URL:[self _sourceStoreURL]
                                                                options:nil
                                                                  error:error];
}

#pragma mark - Keychain

- (BOOL) isMigrationNeededForKeychain {
  NSInteger version = [self.keychainService _obtainKeychainVersion];
  if (version < kKeychainServiceCurrentKeychainVersionValue) {
    return YES;
  }
  return NO;
}

- (BOOL) migratekeychain:(__unused NSError **)error {
  NSInteger version = [self.keychainService _obtainKeychainVersion];
  for (NSInteger migrateVersion = version; migrateVersion < kKeychainServiceCurrentKeychainVersionValue; ++migrateVersion) {
    [self _migrateKeychainFromVersion:migrateVersion toVersion:migrateVersion + 1];
  }
  return YES;
}

#pragma mark - MigrationManagerDelegate

- (NSArray *) migrationManager:(__unused MigrationManager *)migrationManager mappingModelsForSourceModel:(__unused NSManagedObjectModel *)sourceModel {
  return nil;
}

- (void) migrationManager:(__unused MigrationManager *)migrationManager didMigrationFromSourceVersion:(NSInteger)sourceVersion destinationVersion:(NSInteger)destinationVersion {
  [self _migrateKeychainFromVersion:sourceVersion toVersion:destinationVersion];
}

#pragma mark - Private

- (void) _migrateKeychainFromVersion:(NSInteger)fromVersion toVersion:(NSInteger)toVersion {
  if (fromVersion == 1 && toVersion == 2) {
    NSArray <NSString *> *rawKeys = [self.keychainService _obtainRawKeys];
    NSMutableArray <NSString *> *keysForRemove = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in rawKeys) {
      NSArray *components = [key componentsSeparatedByString:@"_"];
      if ([components count] != 2 || [key hasPrefix:kKeychainServiceV2ItemPrefix]) {
        continue;
      }
      NSInteger chainId = [[components lastObject] integerValue];
      if (chainId == BlockchainNetworkTypeRopsten) { //Skip Ropsten network
        continue;
      } else {
        NSDictionary *item = [self.keychainService _obtainItemWithKey:key];
        NSString *masterTokenAddress = [components firstObject];
        NSString *uid = nil;
        {
          NSManagedObjectContext *context = self.managedObjectContext;
          if (!context) {
            uid = [[NSUUID UUID] UUIDString];
          } else {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[MasterTokenModelObject entityName]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.address = %@", masterTokenAddress];
            [fetchRequest setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            if ([fetchedObjects count] == 0) {
              uid = [[NSUUID UUID] UUIDString];
            } else {
              MasterTokenModelObject *masterTokenModelObject = [fetchedObjects firstObject];
              AccountModelObject *accountModelObject = masterTokenModelObject.fromNetworkMaster.fromAccount;
              if (accountModelObject) {
                uid = accountModelObject.uid;
              } else {
                uid = [[NSUUID UUID] UUIDString];
              }
            }
          }
        }
        
        NSString *newKey = [self.keychainService _keyForUID:uid];
        
        id keyData = item[kKeychainServiceV1KeydataField];
        id entropyData = item[kKeychainServiceEntropyField];
        id historyData = item[kKeychainServiceV1PurchaseHistoryField];

        {
          [keysForRemove addObject:key];
          
          NSMutableDictionary *newItem = [[self.keychainService _obtainItemWithKey:newKey] mutableCopy];
          if (keyData) {
            NSString *keydataKey = [self.keychainService _keyForAddress:masterTokenAddress chainID:chainId];
            newItem[keydataKey] = keyData;
          }
          if (historyData) {
            NSString *historyDataKey = [self.keychainService _historyKeyForAddress:masterTokenAddress chainID:chainId];
            newItem[historyDataKey] = historyData;
          }
          if (entropyData) {
            newItem[kKeychainServiceEntropyField] = entropyData;
          } else {
            newItem[kKeychainServiceBackupField] = @YES;
          }
          [self.keychainService _storeItem:newItem withKey:newKey];
        }
      }
    }
    for (NSString *key in keysForRemove) {
      [self.keychainService _removeItemWithKey:key];
    }
    [self.keychainService _storeKeychainVersion:toVersion];
  }
  [self _tearDownCoreData];
}

#pragma mark - CoreData Stack

- (NSManagedObjectContext *)managedObjectContext
{
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  _managedObjectContext.persistentStoreCoordinator = coordinator;
  
  return _managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  
  NSString *momPath = [[NSBundle mainBundle] pathForResource:kMigrationServiceMomFilename
                                                      ofType:kMigrationServiceMomdExtension];
  
  if (!momPath) {
    momPath = [[NSBundle mainBundle] pathForResource:kMigrationServiceMomFilename
                                              ofType:kMigrationServiceMomExtension];
  }
  
  NSURL *url = [NSURL fileURLWithPath:momPath];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  NSError *error = nil;
  
  NSDictionary *options = nil;
  if ([self isMigrationNeeded]) {
    options = @{NSInferMappingModelAutomaticallyOption: @YES,
                NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}};
  } else {
    options = @{NSInferMappingModelAutomaticallyOption: @YES,
                NSSQLitePragmasOption: @{@"journal_mode": @"WAL"}};
  }
  
  NSManagedObjectModel *mom = [self managedObjectModel];
  
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  
  if (![_persistentStoreCoordinator addPersistentStoreWithType:[self _sourceStoreType]
                                                 configuration:nil
                                                           URL:[self _sourceStoreURL]
                                                       options:options
                                                         error:&error]) {
    
    [self _tearDownCoreData];
  }
  
  return _persistentStoreCoordinator;
}

- (NSString *) _sourceStoreType {
  return NSSQLiteStoreType;
}

- (NSURL *) _sourceStoreURL {
  NSURL *directory = [self.fileManager containerURLForSecurityApplicationGroupIdentifier:kAppGroupIdentifier];
  NSURL *storeURL = [directory URLByAppendingPathComponent:kCoreDataName];
  return storeURL;
}

- (void) _tearDownCoreData {
  _managedObjectContext = nil;
  _managedObjectModel = nil;
  _persistentStoreCoordinator = nil;
}

@end
