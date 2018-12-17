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
#import "MasterTokenBody.h"

#import "MasterTokenModelObject.h"
#import "MasterTokenPlainObject.h"
#import "TokenModelObject.h"
#import "TokenPlainObject.h"
#import "FiatPriceModelObject.h"
#import "NetworkModelObject.h"
#import "NetworkPlainObject.h"

#define DEBUG_BALANCE 0
#define DEBUG_TOKENS 0

#if !DEBUG
  #undef DEBUG_BALANCE
  #undef DEBUG_TOKENS
  #define DEBUG_TOKENS 0
  #define DEBUG_BALANCE 0
#endif

#if DEBUG_TOKENS || DEBUG_BALANCE
static NSString *const kMEWDonateAddress = @"0xDECAF9CD2367cdbb726E904cD6397eDFcAe6068D";
#endif

static NSString *const TokensABI = @"[{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"name\",\"type\":\"bool\"},{\"name\":\"website\",\"type\":\"bool\"},{\"name\":\"email\",\"type\":\"bool\"},{\"name\":\"count\",\"type\":\"uint256\"}],\"name\":\"getAllBalance\",\"outputs\":[{\"name\":\"\",\"type\":\"bytes\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"}]";
static NSString *const MainnetTokensContractAddress = @"0xdAFf2b3BdC710EB33A847CCb30A24789c0Ef9c5b";
static NSString *const RopstenTokensContractAddress = @"0xb8e1bbc50fd87ea00d8ce73747ac6f516af26dac";

@implementation TokensServiceImplementation

- (void) updateBalanceOfMasterToken:(MasterTokenPlainObject *)masterToken withCompletion:(TokensServiceCompletion)completion {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  
#if DEBUG_BALANCE
  NSString *originalPublicAddress = masterToken.address;
  if ([masterToken.fromNetworkMaster network] == BlockchainNetworkTypeMainnet) {
    masterToken.address = kMEWDonateAddress;
  }
#endif
  
  MasterTokenBody *body = [self obtainMasterTokenBodyWithMasterToken:masterToken];
  
#if DEBUG_BALANCE
  masterToken.address = originalPublicAddress;
#endif
  [rootSavingContext performBlock:^{
    CompoundOperationBase *compoundOperation = [self.tokensOperationFactory ethereumBalanceWithBody:body inNetwork:[masterToken.fromNetworkMaster network]];
    [compoundOperation setResultBlock:^(__unused NSArray <MasterTokenModelObject *> *data, NSError *error) {
#if DEBUG_BALANCE
      MasterTokenModelObject *masterTokenModelObject = [MasterTokenModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(address)) withValue:masterToken.address inContext:rootSavingContext];
      masterTokenModelObject.balance = [data firstObject].balance;
      masterTokenModelObject.decimals = [data firstObject].decimals;
      [rootSavingContext MR_deleteObjects:data];
      [rootSavingContext MR_saveToPersistentStoreAndWait];
#endif
      dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
          completion(error);
        }
      });
    }];
    [self.operationScheduler addOperation:compoundOperation];
  }];

}

- (void) updateTokenBalancesOfMasterToken:(MasterTokenPlainObject *)masterToken withCompletion:(TokensServiceCompletion)completion {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  
#if DEBUG_TOKENS
  NSString *originalPublicAddress = masterToken.address;
  if ([masterToken.fromNetworkMaster network] == BlockchainNetworkTypeMainnet) {
    masterToken.address = kMEWDonateAddress;
  }
#endif
  
  NSString *contractAddress = nil;
  BlockchainNetworkType network = [masterToken.fromNetworkMaster network];
  if (network == BlockchainNetworkTypeMainnet) {
    contractAddress = MainnetTokensContractAddress;
  } else {
    contractAddress = RopstenTokensContractAddress;
  }
  
  TokensBody *body = [self obtainTokensBodyWithToken:masterToken
                                     contractAddresses:@[contractAddress]];
#if DEBUG_TOKENS
  masterToken.address = originalPublicAddress;
#endif
  [rootSavingContext performBlock:^{
    CompoundOperationBase *compoundOperation = [self.tokensOperationFactory contractBalancesWithBody:body inNetwork:network];
    [compoundOperation setResultBlock:^(NSArray <TokenModelObject *> *data, NSError *error) {
      if (!error) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.master.address ==[c] %@", masterToken.address];
        NetworkModelObject *networkModelObject = [NetworkModelObject MR_findFirstWithPredicate:predicate inContext:rootSavingContext];
        if ([data isKindOfClass:[NSArray class]]) {
          if ([networkModelObject.tokens count] == 0) {
            [networkModelObject addTokens:[NSSet setWithArray:data]];
          } else {
            NSMutableArray *tokensToAdd = [[NSMutableArray alloc] initWithArray:data];
            NSMutableArray *tokensToDelete = [[NSMutableArray alloc] initWithCapacity:0];
            
            NSArray <TokenModelObject *> *tokens = [networkModelObject.tokens allObjects];
            for (TokenModelObject *token in tokens) {
              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.address ==[c] %@", token.address];
              TokenModelObject *refreshingToken = [[data filteredArrayUsingPredicate:predicate] firstObject];
              if (refreshingToken) {
                [tokensToAdd removeObject:refreshingToken];
                token.balance = refreshingToken.balance;
                token.decimals = refreshingToken.decimals;
                [tokensToDelete addObject:refreshingToken];
              } else {
                [tokensToDelete addObject:token];
              }
            }
            if ([tokensToDelete count] > 0) {
              [rootSavingContext MR_deleteObjects:tokensToDelete];
            }
            if ([tokensToAdd count] > 0) {
              [networkModelObject addTokens:[NSSet setWithArray:tokensToAdd]];
            }
          }
        }
      }
      if ([rootSavingContext hasChanges]) {
        [rootSavingContext MR_saveToPersistentStoreWithCompletion:^(__unused BOOL contextDidSave, __unused NSError * _Nullable saveError) {
          dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
              completion(error);
            }
          });
        }];
      } else {
        dispatch_async(dispatch_get_main_queue(), ^{
          if (completion) {
            completion(error);
          }
        });
      }
    }];
    [self.operationScheduler addOperation:compoundOperation];
  }];
}

- (NSUInteger) obtainNumberOfTokensOfMasterToken:(MasterTokenPlainObject *)masterToken {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromNetwork.master.address ==[c] %@", masterToken.address];
  return [TokenModelObject MR_countOfEntitiesWithPredicate:predicate inContext:context];
}

- (NSDecimalNumber *) obtainTokensTotalPriceOfMasterToken:(MasterTokenPlainObject *)masterToken {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromNetwork.master.address ==[c] %@ && SELF.price != nil", masterToken.address];
  NSArray <TokenModelObject *> *tokens = [TokenModelObject MR_findAllWithPredicate:predicate inContext:context];
  NSDecimalNumber *totalPrice = [NSDecimalNumber zero];
  for (TokenModelObject *tokenModelObject in tokens) {
    NSDecimalNumber *decimals = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:[tokenModelObject.decimals shortValue] isNegative:NO];
    NSDecimalNumber *tokenBalance = [tokenModelObject.balance decimalNumberByDividingBy:decimals];
    NSDecimalNumber *price = [tokenBalance decimalNumberByMultiplyingBy:tokenModelObject.price.usdPrice];
    totalPrice = [totalPrice decimalNumberByAdding:price];
  }
  return totalPrice;
}

- (MasterTokenModelObject *) obtainActiveMasterToken {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromNetworkMaster.active = YES && SELF.fromNetworkMaster.fromAccount.active = YES"];
  MasterTokenModelObject *masterToken = [MasterTokenModelObject MR_findFirstWithPredicate:predicate inContext:context];
  return masterToken;
}

- (TokenModelObject *) obtainTokenWithAddress:(NSString *)address ofMasterToken:(MasterTokenPlainObject *)masterToken {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.address ==[c] %@ && SELF.fromNetwork.master.address ==[c] %@", address, masterToken.address];
  TokenModelObject *tokenModelObject = [TokenModelObject MR_findFirstWithPredicate:predicate inContext:context];
  return tokenModelObject;
}

#pragma mark - Private

- (TokensBody *) obtainTokensBodyWithToken:(MasterTokenPlainObject *)token contractAddresses:(NSArray <NSString *>*)contractAddresses {
  TokensBody *body = [[TokensBody alloc] init];
  body.address = token.address;
  body.contractAddresses = contractAddresses;
  body.abi = TokensABI;
  body.method = @"getAllBalance";
  body.nameRequired = YES;
  return body;
}

- (MasterTokenBody *) obtainMasterTokenBodyWithMasterToken:(MasterTokenPlainObject *)masterToken {
  MasterTokenBody *body = [[MasterTokenBody alloc] init];
  body.address = masterToken.address;
  return body;
}

@end
