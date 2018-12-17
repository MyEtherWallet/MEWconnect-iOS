//
//  CacheTrackerImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;

#import "Ponsomizer.h"

#import "CacheTrackerImplementation.h"
#import "CacheRequest.h"
#import "CacheTransactionBatch.h"
#import "CacheTransaction.h"
#import "CacheTransactionSection.h"

@interface CacheTrackerImplementation () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *previousController;
@property (nonatomic, strong) NSFetchedResultsController *controller;
@property (nonatomic, strong) CacheTransactionBatch *transactionBatch;
@property (nonatomic, strong) CacheRequest *cacheRequest;
@property (nonatomic, strong) NSArray *previousFetch; //Flat or Array of Array (if grouping is used)
@property (nonatomic, strong) NSArray <CacheTransactionSection *> *previousSectionsFetch;
@property (nonatomic, strong) NSMapTable <id, NSIndexPath *> *previousFetchObjectToIndexPathMap;
@property (nonatomic, copy) CacheTrackerObjectPreparationBlock preparationBlock;
@end

@implementation CacheTrackerImplementation
@synthesize delegate;

#pragma mark - Public

- (void)setupWithCacheRequest:(CacheRequest *)cacheRequest {
  self.cacheRequest = cacheRequest;
  NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
  NSFetchRequest *fetchRequest = [self fetchRequestWithCacheRequest:cacheRequest];
  self.controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                        managedObjectContext:defaultContext
                                                          sectionNameKeyPath:cacheRequest.sections ? [fetchRequest.sortDescriptors firstObject].key : nil
                                                                   cacheName:nil];
  self.controller.delegate = self;
  [self.controller performFetch:nil];
}

- (void) setupWithCacheRequest:(CacheRequest *)cacheRequest preparationObjectBlock:(CacheTrackerObjectPreparationBlock)block {
  self.preparationBlock = block;
  [self setupWithCacheRequest:cacheRequest];
}

- (void)filterResultsWithPredicate:(NSPredicate *)predicate {
  NSParameterAssert(self.controller);
  self.controller.fetchRequest.predicate = predicate;
  [self.controller performFetch:nil];
}

- (void) filterResultsWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray <NSSortDescriptor *> *)sortDescriptors {
  NSParameterAssert(self.controller);
  if (self.cacheRequest.sections) {
    if (!(self.controller.sectionNameKeyPath != nil && [[sortDescriptors firstObject].key isEqualToString:self.controller.sectionNameKeyPath])) {
      NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
      NSFetchRequest *fetchRequest = [self fetchRequestWithCacheRequest:self.cacheRequest];
      NSString *sectionKeyPath = nil;
      if ([sortDescriptors count] > 1) {
        sectionKeyPath = self.cacheRequest.sections ? [fetchRequest.sortDescriptors firstObject].key : nil;
      }
      self.controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                            managedObjectContext:defaultContext
                                                              sectionNameKeyPath:sectionKeyPath
                                                                       cacheName:nil];
      self.controller.delegate = self;
    }
  }
  self.controller.fetchRequest.predicate = predicate;
  self.controller.fetchRequest.sortDescriptors = sortDescriptors;
  [self.controller performFetch:nil];
}

- (NSFetchRequest *)fetchRequestWithCacheRequest:(CacheRequest *)cacheRequest {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[cacheRequest.objectClass entityName]];
  [fetchRequest setPredicate:cacheRequest.predicate];
  [fetchRequest setSortDescriptors:cacheRequest.sortDescriptors];
  return fetchRequest;
}

- (CacheTransactionBatch *)obtainTransactionBatchFromCurrentCache {
  CacheTransactionBatch *batch = [CacheTransactionBatch new];
  NSArray *ignoringProperties = self.cacheRequest.ignoringProperties;
  for (NSUInteger i = 0; i < _previousFetch.count; ++i) {
    id object = _previousFetch[i];
    id plainObject = [self.ponsomizer convertObject:object ignoringProperties:ignoringProperties];
    NSIndexPath *oldIndexPath = [self.previousFetchObjectToIndexPathMap objectForKey:object];
    NSParameterAssert(oldIndexPath);
    if (![self.controller.fetchedObjects containsObject:object] ||
        ![self.controller isEqual:self.previousController]) {
      if (self.preparationBlock) {
        self.preparationBlock(plainObject);
      }
      CacheTransaction *transaction = [CacheTransaction transactionWithObject:plainObject
                                                                 oldIndexPath:oldIndexPath
                                                             updatedIndexPath:nil
                                                                   objectType:nil
                                                                   changeType:NSFetchedResultsChangeDelete];
      [batch addTransaction:transaction];
      [self _deleteIndexPathForObject:object];
    } else {
      NSIndexPath *newIndexPath = [self.controller indexPathForObject:object];
      if (![newIndexPath isEqual:oldIndexPath]) {
        [self _saveIndexPath:newIndexPath forObject:object];
      }
    }
  }
  for (NSUInteger i = 0; i < self.controller.fetchedObjects.count; ++i) {
    id object = self.controller.fetchedObjects[i];
    id plainObject = [self.ponsomizer convertObject:object ignoringProperties:ignoringProperties];
    NSIndexPath *indexPath = [self.controller indexPathForObject:object];
    NSParameterAssert(indexPath);
    if (![_previousFetch containsObject:object] ||
        ![self.controller isEqual:self.previousController]) {
      if (self.preparationBlock) {
        self.preparationBlock(plainObject);
      }
      CacheTransaction *transaction = [CacheTransaction transactionWithObject:plainObject
                                                                 oldIndexPath:nil
                                                             updatedIndexPath:indexPath
                                                                   objectType:NSStringFromClass(self.cacheRequest.objectClass)
                                                                   changeType:NSFetchedResultsChangeInsert];
      [batch addTransaction:transaction];
    }
    [self _saveIndexPath:indexPath forObject:object];
  }
  _previousFetch = self.controller.fetchedObjects;
  [self _updateSectionsIfNeededForBatch:batch];
  self.previousController = self.controller;
  return batch;
}

- (CacheTransactionBatch *) obtainReloadTrasactionBatchFromCurrentCache {
  CacheTransactionBatch *batch = [CacheTransactionBatch new];
  NSArray *ignoringProperties = self.cacheRequest.ignoringProperties;
  for (NSUInteger i = 0; i < self.controller.fetchedObjects.count; ++i) {
    id object = self.controller.fetchedObjects[i];
    id plainObject = [self.ponsomizer convertObject:object ignoringProperties:ignoringProperties];
    NSIndexPath *indexPath = [self.controller indexPathForObject:object];
    if (self.preparationBlock) {
      self.preparationBlock(plainObject);
    }
    CacheTransaction *transaction = [CacheTransaction transactionWithObject:plainObject
                                                               oldIndexPath:indexPath
                                                           updatedIndexPath:indexPath
                                                                 objectType:NSStringFromClass(self.cacheRequest.objectClass)
                                                                 changeType:NSFetchedResultsChangeUpdate];
    [batch addTransaction:transaction];
  }
  return batch;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(__unused NSFetchedResultsController *)controller {
  self.transactionBatch = [CacheTransactionBatch new];
}

- (void)controller:(__unused NSFetchedResultsController *)controller didChangeObject:(NSManagedObject *)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)changeType newIndexPath:(NSIndexPath *)newIndexPath {
  NSArray *ignoringProperties = self.cacheRequest.ignoringProperties;
  id plainObject = [self.ponsomizer convertObject:anObject ignoringProperties:ignoringProperties];
  if (self.preparationBlock) {
    self.preparationBlock(plainObject);
  }
  if (![indexPath isEqual:newIndexPath] && changeType == NSFetchedResultsChangeUpdate) {
    changeType = NSFetchedResultsChangeMove;
  }
  CacheTransaction *transaction = [CacheTransaction transactionWithObject:plainObject
                                                             oldIndexPath:indexPath
                                                         updatedIndexPath:newIndexPath
                                                               objectType:NSStringFromClass(self.cacheRequest.objectClass)
                                                               changeType:changeType];
  if (newIndexPath) {
    [self _saveIndexPath:newIndexPath forObject:anObject];
  } else if (indexPath) {
    [self _deleteIndexPathForObject:anObject];
  }
  
  [self.transactionBatch addTransaction:transaction];
}

- (void)controllerDidChangeContent:(__unused NSFetchedResultsController *)controller {
  if ([self.transactionBatch isEmpty]) {
    return;
  }
  _previousFetch = self.controller.fetchedObjects;
  [self _updateSectionsIfNeededForBatch:self.transactionBatch];
  self.previousController = self.controller;
  [self.delegate didProcessTransactionBatch:self.transactionBatch];
}

#pragma mark - Private

- (void) _updateSectionsIfNeededForBatch:(CacheTransactionBatch *)batch {
  NSMutableArray <CacheTransactionSection *> *currentSections = [[NSMutableArray alloc] initWithCapacity:0];
  for (id <NSFetchedResultsSectionInfo> sectionInfo in self.controller.sections) {
    CacheTransactionSection *section = [CacheTransactionSection transactionSectionWithName:sectionInfo.name ?: @""
                                                                                  oldIndex:-1
                                                                              updatedIndex:-1
                                                                                changeType:0];
    [currentSections addObject:section];
  }
  
  for (NSUInteger i = 0; i < _previousSectionsFetch.count; ++i) {
    id object = _previousSectionsFetch[i];
    if (![currentSections containsObject:object] ||
        ![self.controller isEqual:self.previousController]) {
      
      CacheTransactionSection *transactionSection = [CacheTransactionSection transactionSectionWithName:_previousSectionsFetch[i].name ?: @""
                                                                                               oldIndex:i
                                                                                           updatedIndex:NSNotFound
                                                                                             changeType:NSFetchedResultsChangeDelete];
      [batch addSection:transactionSection];
    }
  }
  for (NSUInteger i = 0; i < currentSections.count; ++i) {
    id object = currentSections[i];
    if (![_previousSectionsFetch containsObject:object] ||
        ![self.controller isEqual:self.previousController]) {
      CacheTransactionSection *transactionSection = [CacheTransactionSection transactionSectionWithName:currentSections[i].name ?: @""
                                                                                               oldIndex:NSNotFound
                                                                                           updatedIndex:i
                                                                                             changeType:NSFetchedResultsChangeInsert];
      [batch addSection:transactionSection];
    }
  }
  
  _previousSectionsFetch = currentSections;
}

- (void) _saveIndexPath:(NSIndexPath *)indexPath forObject:(id)object {
  NSParameterAssert(indexPath);
  NSParameterAssert(object);
  [self _deleteIndexPathForObject:object];
  if (!_previousFetchObjectToIndexPathMap) {
    _previousFetchObjectToIndexPathMap = [NSMapTable strongToStrongObjectsMapTable];
  }
  [_previousFetchObjectToIndexPathMap setObject:indexPath forKey:object];
}

- (void) _deleteIndexPathForObject:(id)object {
  NSParameterAssert(object);
  [_previousFetchObjectToIndexPathMap removeObjectForKey:object];
}

@end
