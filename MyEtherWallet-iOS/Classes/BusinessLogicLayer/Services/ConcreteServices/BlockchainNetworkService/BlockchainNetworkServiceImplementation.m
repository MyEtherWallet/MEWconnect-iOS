//
//  BlockchainNetworkServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;

#import "BlockchainNetworkServiceImplementation.h"

#import "AccountModelObject.h"
#import "NetworkModelObject.h"
#import "MasterTokenModelObject.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"

#import "BlockchainNetworkTypes.h"

@implementation BlockchainNetworkServiceImplementation

- (NetworkModelObject *) obtainActiveNetwork {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.active = YES && SELF.fromAccount.active = YES"];
  NetworkModelObject *network = [NetworkModelObject MR_findFirstWithPredicate:predicate inContext:context];
  return network;
}

- (void)selectNetwork:(NetworkPlainObject *)network inAccount:(AccountPlainObject *)account {
  NSParameterAssert(network);
  NSParameterAssert(account);
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlockAndWait:^{
    AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(uid)) withValue:account.uid inContext:rootSavingContext];
    for (NetworkModelObject *networkModelObject in accountModelObject.networks) {
      if ([networkModelObject.chainID isEqual:network.chainID]) {
        networkModelObject.active = @YES;
      } else {
        networkModelObject.active = @NO;
      }
    }
    if ([rootSavingContext hasChanges]) {
      [rootSavingContext MR_saveToPersistentStoreAndWait];
    }
  }];
}

- (NetworkModelObject *) createNetworkWithChainID:(NSInteger)chainID inAccount:(AccountPlainObject *)account {
  __block NetworkModelObject *createdNetwork = nil;
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  [rootSavingContext performBlockAndWait:^{
    AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(uid)) withValue:account.uid inContext:rootSavingContext];
    
    NetworkModelObject *networkModelObject = [NetworkModelObject MR_createEntityInContext:rootSavingContext];
    networkModelObject.chainID = @(chainID);
    
    MasterTokenModelObject *masterTokenModelObject = [MasterTokenModelObject MR_createEntityInContext:rootSavingContext];
    masterTokenModelObject.name = NSStringNameFromBlockchainNetworkType(chainID);
    masterTokenModelObject.symbol = NSStringCurrencySymbolFromBlockchainNetworkType(chainID);
    
    masterTokenModelObject.fromNetworkMaster = networkModelObject;
    [accountModelObject addNetworksObject:networkModelObject];
    [rootSavingContext MR_saveToPersistentStoreAndWait];
    
    createdNetwork = [[NSManagedObjectContext MR_defaultContext] objectWithID:networkModelObject.objectID];
  }];
  return createdNetwork;
}

@end
