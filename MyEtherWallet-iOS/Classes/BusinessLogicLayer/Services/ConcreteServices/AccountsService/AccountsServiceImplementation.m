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

#import "MEWwallet.h"
#import "KeychainService.h"

#import "AccountsServiceImplementation.h"

#import "NetworkModelObject.h"
#import "NetworkPlainObject.h"
#import "AccountModelObject.h"
#import "AccountPlainObject.h"

@implementation AccountsServiceImplementation

- (AccountModelObject *) obtainAccountWithAccount:(AccountPlainObject *)account {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  return [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(uid)) withValue:account.uid inContext:context];
}

- (AccountModelObject *) obtainActiveAccount {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  //TODO: multi-account support
  return [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(active)) withValue:@YES inContext:context];
}

- (AccountModelObject *) obtainOrCreateActiveAccount {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  //TODO: multi-account support
  AccountModelObject *account = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(active)) withValue:@YES inContext:context];
  if (!account) {
    account = [self _createNewAccountInContext:context];
  }
  return account;
}

- (NSArray<NSString *> *) bip32MnemonicsWords {
  return [self.MEWwallet obtainBIP32Words];
}

- (void) accountBackedUp:(AccountPlainObject *)account {
  [self.keychainService saveBackupStatus:YES forAccount:account];
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlockAndWait:^{
    AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(uid)) withValue:account.uid inContext:rootSavingContext];
    accountModelObject.backedUp = @YES;
    [rootSavingContext MR_saveToPersistentStoreAndWait];
  }];
}

- (void) deleteAccount:(AccountPlainObject *)account {
  [self.keychainService removeDataOfAccount:account];
  
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlockAndWait:^{
    AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(uid)) withValue:account.uid inContext:rootSavingContext];
    [accountModelObject MR_deleteEntity];
    [rootSavingContext MR_saveToPersistentStoreAndWait];
  }];
}

- (void) resetAccounts {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlockAndWait:^{
    NSArray <AccountModelObject *> *accounts = [AccountModelObject MR_findAllInContext:rootSavingContext];
    [rootSavingContext MR_deleteObjects:accounts];
    [rootSavingContext MR_saveToPersistentStoreAndWait];
  }];
}

#pragma mark - Private

- (AccountModelObject *) _createNewAccountInContext:(NSManagedObjectContext *)context {
  __block AccountModelObject *createdAccount = nil;
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlockAndWait:^{
    AccountModelObject *accountModelObject = [AccountModelObject MR_createEntityInContext:rootSavingContext];
    accountModelObject.name = @"Account";
    accountModelObject.uid = [[NSUUID UUID] UUIDString];
    accountModelObject.active = @YES;
    [rootSavingContext MR_saveToPersistentStoreAndWait];
    
    createdAccount = [context objectWithID:accountModelObject.objectID];
  }];
  return createdAccount;
}

@end
