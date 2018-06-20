//
//  TokensServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 20/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;

#import "OperationScheduler.h"
#import "CompoundOperationBase.h"

#import "TokensOperationFactory.h"

#import "TokensServiceImplementation.h"

#import "TokensBody.h"

#import "TokenModelObject.h"

#define DEBUG_TOKENS 1
#if !DEBUG
  #undef DEBUG_TOKENS
  #define DEBUG_TOKENS 0
#endif

#if DEBUG_TOKENS
static NSString *const kMEWDonateAddress = @"0xDECAF9CD2367cdbb726E904cD6397eDFcAe6068D";
#endif

static NSString *const TokensABI = @"[{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"name\",\"type\":\"bool\"},{\"name\":\"website\",\"type\":\"bool\"},{\"name\":\"email\",\"type\":\"bool\"},{\"name\":\"count\",\"type\":\"uint256\"}],\"name\":\"getAllBalance\",\"outputs\":[{\"name\":\"\",\"type\":\"bytes\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"}]";
static NSString *const TokensContractAddress = @"0xBE1ecF8e340F13071761e0EeF054d9A511e1Cb56";

@implementation TokensServiceImplementation

- (void) updateEthereumBalanceForAddress:(NSString *)address withCompletion:(TokensServiceCompletion)completion {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  
#if DEBUG_TOKENS
  address = kMEWDonateAddress;
#endif
  
  TokensBody *body = [self obtainEthereumBodyWithAddress:address];
  [rootSavingContext performBlock:^{
    CompoundOperationBase *compoundOperation = [self.tokensOperationFactory ethereumBalanceWithBody:body];
    [compoundOperation setResultBlock:^(id data, NSError *error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
          completion(error);
        }
      });
    }];
    [self.operationScheduler addOperation:compoundOperation];
  }];
}

- (void) updateTokenBalancesForAddress:(NSString *)address withCompletion:(TokensServiceCompletion)completion {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  
#if DEBUG_TOKENS
  address = kMEWDonateAddress;
#endif
  
  TokensBody *body = [self obtainTokensBodyWithAddress:address
                                     contractAddresses:@[TokensContractAddress]];
  [rootSavingContext performBlock:^{
    CompoundOperationBase *compoundOperation = [self.tokensOperationFactory contractBalancesWithBody:body];
    [compoundOperation setResultBlock:^(id data, NSError *error) {
      if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray *tokens = [[TokenModelObject MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"SELF.address != nil"] inContext:rootSavingContext] mutableCopy];
        [tokens removeObjectsInArray:data];
        if ([tokens count] > 0) {
          [rootSavingContext MR_deleteObjects:tokens];
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

- (TokenModelObject *) obtainEthereum {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  return [TokenModelObject MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"SELF.address == nil"] inContext:context];
}

- (NSArray <TokenModelObject *> *) obtainTokens {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  return [TokenModelObject MR_findAllSortedBy:NSStringFromSelector(@selector(name))
                                    ascending:YES
                                    inContext:context];
}

- (NSUInteger) obtainNumberOfTokens {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  return [TokenModelObject MR_countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"SELF.address != nil"] inContext:context];
}

- (void) clearTokens {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlock:^{
    [TokenModelObject MR_truncateAllInContext:rootSavingContext];
    [rootSavingContext MR_saveToPersistentStoreAndWait];
  }];
}

#pragma mark - Private

- (TokensBody *) obtainEthereumBodyWithAddress:(NSString *)address {
  TokensBody *body = [[TokensBody alloc] init];
  body.address = address;
  return body;
}

- (TokensBody *) obtainTokensBodyWithAddress:(NSString *)address contractAddresses:(NSArray <NSString *>*)contractAddresses {
  TokensBody *body = [[TokensBody alloc] init];
  body.address = address;
  body.contractAddresses = contractAddresses;
  body.abi = TokensABI;
  body.method = @"getAllBalance";
  body.nameRequired = YES;
  return body;
}

@end
