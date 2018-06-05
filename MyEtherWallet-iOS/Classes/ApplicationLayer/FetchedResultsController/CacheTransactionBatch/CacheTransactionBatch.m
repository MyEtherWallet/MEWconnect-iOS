//
//  CacheTransactionBatch.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CacheTransactionBatch.h"
#import "CacheTransaction.h"

@interface CacheTransactionBatch ()
@end

@implementation CacheTransactionBatch {
  NSMutableOrderedSet *_insertTransactions;
  NSMutableOrderedSet *_updateTransactions;
  NSMutableOrderedSet *_deleteTransactions;
  NSMutableOrderedSet *_moveTransactions;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (void)addTransaction:(CacheTransaction *)transaction {
  switch (transaction.changeType) {
    case NSFetchedResultsChangeInsert: {
      if (!_insertTransactions) {
        _insertTransactions = [[NSMutableOrderedSet alloc] init];
      }
      [_insertTransactions addObject:transaction];
      break;
    }
    case NSFetchedResultsChangeDelete: {
      if (!_deleteTransactions) {
        _deleteTransactions = [[NSMutableOrderedSet alloc] init];
      }
      [_deleteTransactions addObject:transaction];
      break;
    }
    case NSFetchedResultsChangeMove: {
      if (!_moveTransactions) {
        _moveTransactions = [[NSMutableOrderedSet alloc] init];
      }
      [_moveTransactions addObject:transaction];
      break;
    }
    case NSFetchedResultsChangeUpdate: {
      if (!_updateTransactions) {
        _updateTransactions = [[NSMutableOrderedSet alloc] init];
      }
      [_updateTransactions addObject:transaction];
      break;
    }
      
    default:
      break;
  }
}

- (BOOL)isEmpty {
  return  [_insertTransactions count] == 0 &&
  [_updateTransactions count] == 0 &&
  [_deleteTransactions count] == 0 &&
  [_moveTransactions count] == 0;
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

@end
