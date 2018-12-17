//
//  CacheTransactionBatch.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CacheTransactionBatch.h"
#import "CacheTransaction.h"
#import "CacheTransactionSection.h"

@interface CacheTransactionBatch ()
@end

@implementation CacheTransactionBatch {
  NSMutableOrderedSet <CacheTransaction *> *_deleteTransactions;
  NSMutableOrderedSet <CacheTransaction *> *_insertTransactions;
  NSMutableOrderedSet <CacheTransaction *> *_updateTransactions;
  NSMutableOrderedSet <CacheTransaction *> *_moveTransactions;
  
  NSMutableArray <CacheTransactionSection *> *_sections;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (void)addTransaction:(CacheTransaction *)transaction {
  switch (transaction.changeType) {
    case NSFetchedResultsChangeDelete: {
      if (!_deleteTransactions) {
        _deleteTransactions = [[NSMutableOrderedSet alloc] init];
      }
      [_deleteTransactions addObject:transaction];
      [_deleteTransactions sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(oldIndexPath)) ascending:NO]]];
      break;
    }
    case NSFetchedResultsChangeInsert: {
      if (!_insertTransactions) {
        _insertTransactions = [[NSMutableOrderedSet alloc] init];
      }
      [_insertTransactions addObject:transaction];
      [_insertTransactions sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(updatedIndexPath)) ascending:YES]]];
      break;
    }
    case NSFetchedResultsChangeUpdate: {
      if (!_updateTransactions) {
        _updateTransactions = [[NSMutableOrderedSet alloc] init];
      }
      [_updateTransactions addObject:transaction];
      [_updateTransactions sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(updatedIndexPath)) ascending:YES]]];
      
      break;
    }
    case NSFetchedResultsChangeMove: {
      if (!_moveTransactions) {
        _moveTransactions = [[NSMutableOrderedSet alloc] init];
      }
      [_moveTransactions addObject:transaction];
      break;
    }
    default:
      break;
  }
}

- (void)addSection:(CacheTransactionSection *)section {
  if (!_sections) {
    _sections = [[NSMutableArray alloc] init];
  }
  [_sections addObject:section];
}

- (BOOL)isEmpty {
  return [_deleteTransactions count] == 0 &&
         [_insertTransactions count] == 0 &&
         [_updateTransactions count] == 0 &&
         [_moveTransactions count] == 0 &&
         [_sections count] == 0;
}

- (NSOrderedSet *)insertTransactions {
  return [_insertTransactions copy];
}

- (NSOrderedSet *)updateTransactions {
  return [_updateTransactions copy];
}

- (NSOrderedSet *)deleteTransactions {
  return [_deleteTransactions copy];
}

- (NSOrderedSet *)moveTransactions {
  return [_moveTransactions copy];
}

- (NSOrderedSet <CacheTransactionSection *> *)sections {
  return [_sections copy];
}

@end
