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

#import "NetworkModelObject.h"
#import "TokenModelObject.h"
#import "FiatPriceModelObject.h"
#import "MasterTokenModelObject.h"

#import "FiatPricesServiceImplementation.h"

static NSString *const FiatPricesEthereumSymbol = @"ETH";

#define DEBUG_PRICES 0
#if !DEBUG
#undef DEBUG_PRICES
#define DEBUG_PRICES 0
#endif

@implementation FiatPricesServiceImplementation

- (void) updateFiatPricesWithCompletion:(FiatPricesServiceCompletion)completion {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromAccount.active == YES && SELF.active == YES"];
  NetworkModelObject *networkModelObject = [NetworkModelObject MR_findFirstWithPredicate:predicate inContext:rootSavingContext];
  
  FiatPricesQuery *query = [self _obtainTokensQueryWithNetwork:networkModelObject];
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
    [compoundOperation setResultBlock:^(__unused id data, NSError *error) {
      if (!error) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromToken.@count == 0"];
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

- (FiatPricesQuery *) _obtainTokensQueryWithNetwork:(NetworkModelObject *)networkModelObject {
  NSSet <NSString *> *symbols = [networkModelObject.tokens valueForKeyPath:NSStringFromSelector(@selector(symbol))];
  NSString *masterSymbol = networkModelObject.master.symbol;
  if (masterSymbol) {
    symbols = [symbols setByAddingObject:masterSymbol];
  }
  if ([symbols count] == 0) {
    return nil;
  }
  NSMutableSet <NSString *> *tokensSet = [[NSMutableSet alloc] init];
  [tokensSet unionSet:symbols];
  
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
