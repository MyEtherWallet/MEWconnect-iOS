//
//  AccountsServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;

#import "OperationScheduler.h"
#import "CompoundOperationBase.h"

#import "AccountsOperationFactory.h"

#import "MEWwallet.h"
#import "KeychainService.h"

#import "AccountsServiceImplementation.h"

#import "AccountsBody.h"

#import "NetworkModelObject.h"
#import "NetworkPlainObject.h"
#import "AccountModelObject.h"
#import "AccountPlainObject.h"

#define DEBUG_BALANCE 1
#if !DEBUG
#undef DEBUG_BALANCE
#define DEBUG_BALANCE 0
#endif

#if DEBUG_BALANCE
static NSString *const kMEWDonateAddress = @"0xDECAF9CD2367cdbb726E904cD6397eDFcAe6068D";
#endif

@implementation AccountsServiceImplementation

- (void) updateBalanceForAccount:(AccountPlainObject *)account withCompletion:(AccountsServiceCompletionBlock)completion {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];

#if DEBUG_BALANCE
  NSString *originalPublicAddress = account.publicAddress;
  account.publicAddress = kMEWDonateAddress;
#endif
  
  AccountsBody *body = [self obtainEthereumBodyWithAccount:account];
  
#if DEBUG_BALANCE
  account.publicAddress = originalPublicAddress;
#endif
  [rootSavingContext performBlock:^{
    CompoundOperationBase *compoundOperation = [self.accountsOperationFactory ethereumBalanceWithBody:body inNetwork:[account.fromNetwork network]];
    [compoundOperation setResultBlock:^(NSArray <AccountModelObject *> *data, NSError *error) {
#if DEBUG_BALANCE
      AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(publicAddress)) withValue:account.publicAddress inContext:rootSavingContext];
      accountModelObject.balance = [data firstObject].balance;
      accountModelObject.decimals = [data firstObject].decimals;
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

- (AccountModelObject *) obtainActiveAccount {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  //TODO: multi-account support
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromNetwork.active == YES && SELF.active == YES"];
  return [AccountModelObject MR_findFirstWithPredicate:predicate inContext:context];
}

- (NSArray <AccountModelObject *> *) obtainAccountsOfActiveNetwork {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fromNetwork.active == YES"];
  return [AccountModelObject MR_findAllWithPredicate:predicate inContext:context];
}

- (void) createNewAccountInNetwork:(NetworkPlainObject *)network password:(NSString *)password words:(NSArray <NSString *> *)words completion:(AccountsServiceCreateCompletionBlock)completion {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  
  NetworkModelObject *networkModelObject = [NetworkModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(chainID)) withValue:@([network network]) inContext:rootSavingContext];
  if (!networkModelObject) {
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(nil);
    });
    return;
  }
  [self.MEWwallet createWalletWithPassword:password words:words network:[network network] completion:^(BOOL success, NSString *address) {
    if (success) {
      [rootSavingContext performBlockAndWait:^{
        AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstOrCreateByAttribute:NSStringFromSelector(@selector(publicAddress)) withValue:address inContext:rootSavingContext];
        [networkModelObject addAccountsObject:accountModelObject];
        [networkModelObject.accounts setValue:@NO forKey:NSStringFromSelector(@selector(active))];
        accountModelObject.active = @YES;
        if (words) {
          accountModelObject.backedUp = @YES;
        }
        [rootSavingContext MR_saveToPersistentStoreAndWait];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        accountModelObject = [accountModelObject MR_inContext:context];
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(accountModelObject);
        });
      }];
    }
  }];
}

- (BOOL) validatePassword:(NSString *)password forAccount:(AccountPlainObject *)account {
  NSString *publicAddress = [self.MEWwallet validatePassword:password publicAddress:account.publicAddress network:[account.fromNetwork network]];
  return [publicAddress isEqualToString:account.publicAddress];
}

- (NSArray<NSString *> *) recoveryMnemonicsWordsForAccount:(AccountPlainObject *)account password:(NSString *)password {
  NSArray *mnemonics = [self.MEWwallet recoveryMnemonicsWordsWithPassword:password publicAddress:account.publicAddress network:[account.fromNetwork network]];
  return mnemonics;
}

- (NSArray<NSString *> *) bip32MnemonicsWords {
  return [self.MEWwallet obtainBIP32Words];
}

- (void) accountBackedUp:(AccountPlainObject *)account {
  [self.keychainService removeEntropyOfPublicAddress:account.publicAddress fromNetwork:[account.fromNetwork network]];
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlockAndWait:^{
    AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(publicAddress)) withValue:account.publicAddress inContext:rootSavingContext];
    accountModelObject.backedUp = @YES;
    [rootSavingContext MR_saveToPersistentStoreAndWait];
  }];
}

- (void) deleteAccount:(AccountPlainObject *)account {
  [self.keychainService removeKeydataOfPublicAddress:account.publicAddress fromNetwork:[account.fromNetwork network]];
  
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlockAndWait:^{
    AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(publicAddress)) withValue:account.publicAddress inContext:rootSavingContext];
    [accountModelObject MR_deleteEntity];
    [rootSavingContext MR_saveToPersistentStoreAndWait];
  }];
}

#pragma mark - Private

- (AccountsBody *) obtainEthereumBodyWithAccount:(AccountPlainObject *)account {
  AccountsBody *body = [[AccountsBody alloc] init];
  body.address = account.publicAddress;
  return body;
}

@end
