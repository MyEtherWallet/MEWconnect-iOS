//
//  MEWWalletImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 29/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import MagicalRecord;
@import libextobjc.EXTScope;

#import "MEWWalletImplementation.h"
#if BETA
#import "MyEtherWallet_iOS_Beta-Swift.h"
#else
#import "MyEtherWallet_iOS-Swift.h"
#endif

#import "BlockchainNetworkTypes.h"

#import "Ponsomizer.h"
#import "KeychainService.h"
#import "BlockchainNetworkService.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "MasterTokenPlainObject.h"

#import "AccountModelObject.h"
#import "NetworkModelObject.h"
#import "MasterTokenModelObject.h"

#import "UIImage+MEWBackground.h"

@implementation MEWWalletImplementation

- (void) createWalletWithPassword:(NSString *)password mnemonicWords:(NSArray<NSString *> *)mnemonicWords account:(AccountPlainObject *)account {
  //Creating new entropy if needed
  if (![self.keychainService obtainEntropyOfAccount:account]) {
    [self.wrapper createWalletWithPassword:password words:mnemonicWords account:account];
  }
}

- (void) createKeysWithChainIDs:(NSSet<NSNumber *> *)chainIDs forAccount:(AccountPlainObject *)account withPassword:(NSString *)password mnemonicWords:(NSArray<NSString *> *)mnemonicWords completion:(MEWwalletCreateCompletionBlock)completion {
  @weakify(self);
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    @strongify(self);
    
    //Creating new entropy if needed
    if (![self.keychainService obtainEntropyOfAccount:account]) {
      [self.wrapper createWalletWithPassword:password words:mnemonicWords account:account];
    }
    
    __block BOOL completed = YES;
    
    NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];
    [rootSavingContext performBlock:^{
      dispatch_group_t queueGroup = dispatch_group_create();
      
      //For everyone chainID
      for (NSNumber *chainID in chainIDs) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.chainID = %@ && SELF.fromAccount.uid = %@", chainID, account.uid];
        NetworkModelObject *networkModelObject = [NetworkModelObject MR_findFirstWithPredicate:predicate inContext:rootSavingContext];
        if (networkModelObject) {
          //Already created
          continue;
        }
        
        NetworkModelObject *generatedNetworkModelObject = [self.networkService createNetworkWithChainID:[chainID integerValue] inAccount:account];
        networkModelObject = [rootSavingContext objectWithID:[generatedNetworkModelObject objectID]];
        
        NSArray <NSString *> *ignoringProperties = @[NSStringFromSelector(@selector(fromAccount)),
                                                     NSStringFromSelector(@selector(tokens))];
        NetworkPlainObject *network = [self.ponsomizer convertObject:networkModelObject ignoringProperties:ignoringProperties];
        
        MasterTokenPlainObject *master = network.master;

        //Then create new private key
        dispatch_group_async(queueGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          NSString *address = [self.wrapper createPrivateKeyWithPassword:password account:account masterToken:master network:[network network]];
          if (address) {
            //And save public address
            [rootSavingContext performBlockAndWait:^{
              networkModelObject.master.address = address;
              master.address = address;
            }];
            
            __block CGSize fullSize;
            __block CGSize cardSize;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
              fullSize = [UIImage fullSize];
              cardSize = [UIImage cardSize];
            });
            
            [UIImage cacheImagesWithSeed:address fullSize:fullSize cardSize:cardSize];
          } else {
            completed = NO;
          }
        });
      }
      dispatch_group_notify(queueGroup, queue, ^{
        [rootSavingContext performBlockAndWait:^{
          [rootSavingContext MR_saveToPersistentStoreAndWait];
        }];
        if (completion) {
          dispatch_async(dispatch_get_main_queue(), ^{
            completion(completed);
          });
        }
      });
    }];
  });
}

- (BOOL) validatePassword:(NSString *)password account:(AccountPlainObject *)account {
  //TODO: Some cleanup
  NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
  AccountModelObject *accountModelObject = [AccountModelObject MR_findFirstByAttribute:NSStringFromSelector(@selector(uid)) withValue:account.uid inContext:defaultContext];
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(tokens)),
                                  NSStringFromSelector(@selector(price)),
                                  NSStringFromSelector(@selector(purchaseHistory))];
  account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
  NetworkPlainObject *anyNetwork = [account.networks anyObject];
  return [self.wrapper validatePasswordWithPassword:password masterToken:anyNetwork.master account:account network:[anyNetwork network]];
}

- (void) signMessage:(MEWConnectMessage *)message password:(NSString *)password masterToken:(MasterTokenPlainObject *)masterToken completion:(MEWWalletDataCompletionBlock)completion {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    NetworkPlainObject *network = masterToken.fromNetworkMaster;
    AccountPlainObject *account = network.fromAccount;
    id signedMessage = [self.wrapper signMessage:message password:password masterToken:masterToken account:account network:[network network]];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(signedMessage);
      });
    }
  });
}

- (void) signTransaction:(MEWConnectTransaction *)transaction password:(NSString *)password masterToken:(MasterTokenPlainObject *)masterToken completion:(MEWWalletDataCompletionBlock)completion {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    NetworkPlainObject *network = masterToken.fromNetworkMaster;
    AccountPlainObject *account = network.fromAccount;
    id signedMessage = [self.wrapper signTransaction:transaction password:password masterToken:masterToken account:account network:[network network]];
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(signedMessage);
      });
    }
  });
}

- (BOOL) isSeedAvailableForAccount:(AccountPlainObject *)account {
  return [self.keychainService obtainEntropyOfAccount:account] != nil;
}

- (BOOL) validateSeedWithWords:(NSArray<NSString *> *)words withNetwork:(NetworkPlainObject *)network {
  NSString *address = [self.wrapper obtainAddressWithWords:words network:[network network]];
  return [network.master.address isEqualToString:address];
}

- (BOOL) validateMnemonics:(NSArray <NSString *> *)words {
  return [self.wrapper validateMnemonicsWithWords:words];
}

- (NSArray <NSString *> *) recoveryMnemonicsWordsWithPassword:(NSString *)password ofAccount:(AccountPlainObject *)account {
  return [self.wrapper recoveryMnemonicsWordsWithPassword:password account:account];
}

- (NSArray <NSString *> *) obtainBIP32Words {
  return [self.wrapper bip39Words];
}

@end
