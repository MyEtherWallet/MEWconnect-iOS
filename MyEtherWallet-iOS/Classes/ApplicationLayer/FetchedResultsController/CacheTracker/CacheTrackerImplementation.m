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

@interface CacheTrackerImplementation () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *controller;
@property (nonatomic, strong) CacheTransactionBatch *transactionBatch;
@property (nonatomic, strong) CacheRequest *cacheRequest;
@property (nonatomic, strong) NSArray *previousFetch;
@end

@implementation CacheTrackerImplementation
@synthesize delegate;

#pragma mark - Public

- (void)setupWithCacheRequest:(CacheRequest *)cacheRequest {
  NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
  NSFetchRequest *fetchRequest = [self fetchRequestWithCacheRequest:cacheRequest];
  self.controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                        managedObjectContext:defaultContext
                                                          sectionNameKeyPath:nil
                                                                   cacheName:nil];
  self.controller.delegate = self;
  [self.controller performFetch:nil];
}

- (void)filterResultsWithPredicate:(NSPredicate *)predicate {
  NSParameterAssert(self.controller);
  self.controller.fetchRequest.predicate = predicate;
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
  for (NSUInteger i = 0; i < self.controller.fetchedObjects.count; ++i) {
    id object = self.controller.fetchedObjects[i];
    if (![_previousFetch containsObject:object]) {
      NSIndexPath *indexPath = [self.controller indexPathForObject:object];
      id plainObject = [self.ponsomizer convertObject:object];
      CacheTransaction *transaction = [CacheTransaction transactionWithObject:plainObject
                                                                 oldIndexPath:nil
                                                             updatedIndexPath:indexPath
                                                                   objectType:NSStringFromClass(self.cacheRequest.objectClass)
                                                                   changeType:NSFetchedResultsChangeInsert];
      [batch addTransaction:transaction];
    }
  }
  for (NSUInteger i = 0; i < _previousFetch.count; ++i) {
    id object = _previousFetch[i];
    if (![self.controller.fetchedObjects containsObject:object]) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
      CacheTransaction *transaction = [CacheTransaction transactionWithObject:nil
                                                                 oldIndexPath:indexPath
                                                             updatedIndexPath:nil
                                                                   objectType:nil
                                                                   changeType:NSFetchedResultsChangeDelete];
      [batch addTransaction:transaction];
    }
  }
  _previousFetch = self.controller.fetchedObjects;
  
  return batch;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  self.transactionBatch = [CacheTransactionBatch new];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(NSManagedObject *)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)changeType newIndexPath:(NSIndexPath *)newIndexPath {
  id plainObject = [self.ponsomizer convertObject:anObject];
  CacheTransaction *transaction = [CacheTransaction transactionWithObject:plainObject
                                                             oldIndexPath:indexPath
                                                         updatedIndexPath:newIndexPath
                                                               objectType:NSStringFromClass(self.cacheRequest.objectClass)
                                                               changeType:changeType];
  [self.transactionBatch addTransaction:transaction];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  if ([self.transactionBatch isEmpty]) {
    return;
  }
  _previousFetch = self.controller.fetchedObjects;
  [self.delegate didProcessTransactionBatch:self.transactionBatch];
}

@end
