//
//  MigrationManager.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import CoreData;

#import "MigrationManager.h"

static NSString *const kMigrationManagerErrorDomain               = @"com.myetherwallet.mewconnect.migration-error-domain";

static NSInteger const kMigrationManagerNoModelsErrorCode         = 1;
static NSInteger const kMigrationManagerNoMappingModelErrorCode   = 2;

static NSString *const kMigrationManagerMomdExtension             = @"momd";
static NSString *const kMigrationManagerMomExtension              = @"mom";

@implementation MigrationManager

- (BOOL)progressivelyMigrateURL:(NSURL *)sourceStoreURL
                         ofType:(NSString *)type
                        toModel:(NSManagedObjectModel *)finalModel
                          error:(NSError **)error {
  
  NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type
                                                                                            URL:sourceStoreURL
                                                                                        options:nil
                                                                                          error:error];
  if (!sourceMetadata) {
    return NO;
  }
  if ([finalModel isConfiguration:nil
      compatibleWithStoreMetadata:sourceMetadata]) {
    if (NULL != error) {
      *error = nil;
    }
    return YES;
  }
  NSManagedObjectModel *sourceModel = [self _sourceModelForSourceMetadata:sourceMetadata];
  NSManagedObjectModel *destinationModel = nil;
  NSMappingModel *mappingModel = nil;
  NSString *modelName = nil;
  if (![self _getDestinationModel:&destinationModel
                     mappingModel:&mappingModel
                        modelName:&modelName
                   forSourceModel:sourceModel
                            error:error]) {
    return NO;
  }
  
  NSArray *mappingModels = @[mappingModel];
  if ([self.delegate respondsToSelector:@selector(migrationManager:mappingModelsForSourceModel:)]) {
    NSArray *explicitMappingModels = [self.delegate migrationManager:self mappingModelsForSourceModel:sourceModel];
    if (explicitMappingModels.count > 0) {
      mappingModels = explicitMappingModels;
    }
  }
  NSURL *destinationStoreURL = [self _destinationStoreURLWithSourceStoreURL:sourceStoreURL
                                                                  modelName:modelName];
  NSMigrationManager *manager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel
                                                               destinationModel:destinationModel];
  BOOL didMigrate = NO;
  for (NSMappingModel *mappingModel in mappingModels) {
    didMigrate = [manager migrateStoreFromURL:sourceStoreURL
                                         type:type
                                      options:nil
                             withMappingModel:mappingModel
                             toDestinationURL:destinationStoreURL
                              destinationType:type
                           destinationOptions:nil
                                        error:error];
  }
  if (!didMigrate) {
    return NO;
  }
  // Migration was successful, move the files around to preserve the source in case things go bad
  if (![self _backupSourceStoreAtURL:sourceStoreURL
         movingDestinationStoreAtURL:destinationStoreURL
                               error:error]) {
    return NO;
  }
  if ([self.delegate respondsToSelector:@selector(migrationManager:didMigrationFromSourceVersion:destinationVersion:)]) {
    NSNumber *sourceVerion = [[sourceModel versionIdentifiers] anyObject];
    NSNumber *destinationVersion = [[destinationModel versionIdentifiers] anyObject];
    [self.delegate migrationManager:self
      didMigrationFromSourceVersion:MAX([sourceVerion integerValue], 1)
                 destinationVersion:[destinationVersion integerValue]];
  }
  // We may not be at the "current" model yet, so recurse
  return [self progressivelyMigrateURL:sourceStoreURL
                                ofType:type
                               toModel:finalModel
                                 error:error];
}

#pragma mark - Private

- (NSManagedObjectModel *) _sourceModelForSourceMetadata:(NSDictionary *)sourceMetadata {
  return [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle bundleForClass:[self class]]]
                                     forStoreMetadata:sourceMetadata];
}

- (BOOL) _getDestinationModel:(NSManagedObjectModel **)destinationModel
                 mappingModel:(NSMappingModel **)mappingModel
                    modelName:(NSString **)modelName
               forSourceModel:(NSManagedObjectModel *)sourceModel
                        error:(NSError **)error {
  NSArray *modelPaths = [self _modelPaths];
  if (modelPaths.count == 0) {
    //Throw an error if there are no models
    if (error) {
      *error = [NSError errorWithDomain:kMigrationManagerErrorDomain
                                   code:kMigrationManagerNoModelsErrorCode
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No models found", nil)}];
    }
    return NO;
  }
  
  //See if we can find a matching destination model
  NSManagedObjectModel *model = nil;
  NSMappingModel *mapping = nil;
  NSString *modelPath = nil;
  for (modelPath in modelPaths) {
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    mapping = [NSMappingModel mappingModelFromBundles:@[[NSBundle bundleForClass:[self class]]]
                                       forSourceModel:sourceModel
                                     destinationModel:model];
    //If we found a mapping model then proceed
    if (mapping) {
      break;
    }
  }
  //We have tested every model, if nil here we failed
  if (!mapping) {
    if (error) {
      *error = [NSError errorWithDomain:kMigrationManagerErrorDomain
                                   code:kMigrationManagerNoMappingModelErrorCode
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No mapping model found", nil)}];
    }
    return NO;
  } else {
    *destinationModel = model;
    *mappingModel = mapping;
    *modelName = modelPath.lastPathComponent.stringByDeletingPathExtension;
  }
  return YES;
}

- (NSURL *) _destinationStoreURLWithSourceStoreURL:(NSURL *)sourceStoreURL
                                         modelName:(NSString *)modelName {
  // We have a mapping model, time to migrate
  NSString *storeExtension = [sourceStoreURL path].pathExtension;
  NSString *storePath = [sourceStoreURL path].stringByDeletingPathExtension;
  // Build a path to write the new store
  storePath = [NSString stringWithFormat:@"%@.%@.%@", storePath, modelName, storeExtension];
  NSURL *url = [NSURL fileURLWithPath:storePath];
  if ([self.fileManager fileExistsAtPath:[url path]]) {
    [self.fileManager removeItemAtURL:url error:nil];
  }
  return url;
}

- (NSArray *) _modelPaths {
  //Find all of the mom and momd files in the Resources directory
  NSMutableArray *modelPaths = [NSMutableArray array];
  NSArray *momdArray = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:kMigrationManagerMomdExtension
                                                                           inDirectory:nil];
  for (NSString *momdPath in momdArray) {
    NSString *resourceSubpath = [momdPath lastPathComponent];
    NSArray *array = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:kMigrationManagerMomExtension
                                                                         inDirectory:resourceSubpath];
    [modelPaths addObjectsFromArray:array];
  }
  NSArray *otherModels = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:kMigrationManagerMomExtension
                                                                             inDirectory:nil];
  [modelPaths addObjectsFromArray:otherModels];
  return modelPaths;
}

#pragma mark - Backup

- (BOOL) _backupSourceStoreAtURL:(NSURL *)sourceStoreURL
     movingDestinationStoreAtURL:(NSURL *)destinationStoreURL
                           error:(NSError **)error {
  NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
  NSString *backupPath = [NSTemporaryDirectory() stringByAppendingPathComponent:guid];
  
  if (![self.fileManager moveItemAtPath:sourceStoreURL.path
                                 toPath:backupPath
                                  error:error]) {
    //Failed to copy the file
    return NO;
  }
  //Move the destination to the source path
  if (![self.fileManager moveItemAtPath:destinationStoreURL.path
                                 toPath:sourceStoreURL.path
                                  error:error]) {
    //Try to back out the source move first, no point in checking it for errors
    [self.fileManager moveItemAtPath:backupPath
                              toPath:sourceStoreURL.path
                               error:nil];
    return NO;
  }
  return YES;
}

@end
