//
//  FiatPricesServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;

#import "OperationScheduler.h"
#import "CompoundOperationBase.h"

#import "FiatPricesOperationFactory.h"

#import "FiatPricesQuery.h"

#import "AccountModelObject.h"
#import "TokenModelObject.h"
#import "FiatPriceModelObject.h"

#import "FiatPricesServiceImplementation.h"

static NSString *const FiatPricesEthereumSymbol = @"ETH";

#define DEBUG_PRICES 1
#if !DEBUG
#undef DEBUG_PRICES
#define DEBUG_PRICES 0
#endif

@implementation FiatPricesServiceImplementation

- (void) updatePriceForEthereumWithCompletion:(FiatPricesServiceCompletion)completion {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  
  FiatPricesQuery *query = [self _obtainEthereumQuery];
  
  [rootSavingContext performBlock:^{
    CompoundOperationBase *compoundOperation = [self.fiatPricesOperationFactory fiatPricesWithQuery:query];
    [compoundOperation setResultBlock:^(id data, NSError *error) {
      if (!error) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromAccount.@count == 0 && SELF.fromToken.@count == 0"];
        NSArray <FiatPriceModelObject *> *ghostsFiatPrices = [FiatPriceModelObject MR_findAllWithPredicate:predicate inContext:rootSavingContext];
        if ([ghostsFiatPrices count] > 0) {
          [rootSavingContext MR_deleteObjects:ghostsFiatPrices];
          [rootSavingContext MR_saveToPersistentStoreAndWait];
        }
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
          completion(error);
        }
      });
    }];
    [self.operationScheduler addOperation:compoundOperation];
  }];
}

- (void) updatePricesForTokensWithCompletion:(FiatPricesServiceCompletion)completion {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromNetwork.active == YES && SELF.active == YES"];
  AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstWithPredicate:predicate inContext:rootSavingContext];
  
  FiatPricesQuery *query = [self _obtainTokensQueryWithAccount:accountModelObject];
  if (!query) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (completion) {
        completion(nil);
      }
    });
    return;
  }
  
  [rootSavingContext performBlock:^{
    CompoundOperationBase *compoundOperation = [self.fiatPricesOperationFactory fiatPricesWithQuery:query];
    [compoundOperation setResultBlock:^(id data, NSError *error) {
      if (!error) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromAccount.@count == 0 && SELF.fromToken.@count == 0"];
        NSArray <FiatPriceModelObject *> *ghostsFiatPrices = [FiatPriceModelObject MR_findAllWithPredicate:predicate inContext:rootSavingContext];
        if ([ghostsFiatPrices count] > 0) {
          [rootSavingContext MR_deleteObjects:ghostsFiatPrices];
          [rootSavingContext MR_saveToPersistentStoreAndWait];
        }
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
          completion(error);
        }
      });
    }];
    [self.operationScheduler addOperation:compoundOperation];
  }];
}

#pragma mark - Private

- (FiatPricesQuery *) _obtainTokensQueryWithAccount:(AccountModelObject *)account {
  NSArray *symbols = [account.tokens valueForKeyPath:NSStringFromSelector(@selector(symbol))];
  if ([symbols count] == 0) {
    return nil;
  }
  NSMutableSet *tokensSet = [[NSMutableSet alloc] init];
  [tokensSet addObjectsFromArray:symbols];
  
  FiatPricesQuery *query = [[FiatPricesQuery alloc] init];
  query.symbols = [tokensSet copy];
#if DEBUG_PRICES
  query.symbols = [NSSet setWithObjects:@"ZRX", @"CMT", @"ELF", @"EOS", @"ENG", @"GNT", @"ICX", @"KIN", @"KNC", @"LRC", @"OMG", @"POLY", @"PPT", @"POWR", @"SNT", @"TRX", @"VEN", nil];
#endif
  return query;
}

- (FiatPricesQuery *) _obtainEthereumQuery {
  FiatPricesQuery *query = [[FiatPricesQuery alloc] init];
  query.symbols = [NSSet setWithObject:FiatPricesEthereumSymbol];
  return query;
}

@end
