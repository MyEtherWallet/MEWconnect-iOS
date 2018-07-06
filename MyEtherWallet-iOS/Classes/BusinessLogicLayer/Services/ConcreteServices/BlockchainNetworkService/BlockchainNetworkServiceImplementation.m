//
//  BlockchainNetworkServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;

#import "NetworkModelObject.h"

#import "BlockchainNetworkServiceImplementation.h"

#import "BlockchainNetworkTypes.h"

@implementation BlockchainNetworkServiceImplementation

- (NetworkModelObject *) obtainActiveNetwork {
  NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.active = YES"];
  NetworkModelObject *network = [NetworkModelObject MR_findFirstWithPredicate:predicate inContext:context];
  return network;
}

- (BOOL) selectNetwork:(BlockchainNetworkType)network {
  NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
  __block BOOL alreadySelected = NO;
  [rootSavingContext performBlockAndWait:^{
    NetworkModelObject *networkModelObject = [NetworkModelObject MR_findFirstOrCreateByAttribute:NSStringFromSelector(@selector(chainID)) withValue:@(network) inContext:rootSavingContext];
    if ([networkModelObject.active boolValue]) {
      alreadySelected = YES;
    } else {
      NSArray *allNetwork = [NetworkModelObject MR_findAllInContext:rootSavingContext];
      for (NetworkModelObject *networkMO in allNetwork) {
        networkMO.active = @NO;
      }
    }
    networkModelObject.active = @YES;
    [rootSavingContext MR_saveToPersistentStoreAndWait];
  }];
  return !alreadySelected;
}

@end
