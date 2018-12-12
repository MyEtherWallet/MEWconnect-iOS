//
//  NewWalletInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "NewWalletInteractor.h"

#import "NewWalletInteractorOutput.h"

#import "MEWConnectFacade.h"
#import "AccountsService.h"
#import "KeychainService.h"
#import "BlockchainNetworkService.h"
#import "MEWwallet.h"
#import "Ponsomizer.h"

#import "NetworkPlainObject.h"
#import "AccountPlainObject.h"
#import "MasterTokenPlainObject.h"

@interface NewWalletInteractor ()
@end

@implementation NewWalletInteractor

#pragma mark - NewWalletInteractorInput

- (void) createNewWalletWithPassword:(NSString *)password words:(NSArray<NSString *> *)words {
  [self.connectFacade disconnect];
  
  [self.accountsService resetAccounts];
  [self.keychainService resetKeychain];
  
  AccountModelObject *accountModelObject = [self.accountsService obtainOrCreateActiveAccount];
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(tokens))];
  AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
  
  NSSet *chainIDs = [NSSet setWithObjects:@(BlockchainNetworkTypeMainnet), @(BlockchainNetworkTypeRopsten), nil];
  @weakify(self);
  [self.mewWallet createKeysWithChainIDs:chainIDs forAccount:account withPassword:password mnemonicWords:words completion:^(__unused BOOL success) {
    @strongify(self);
    
    AccountModelObject *accountModelObject = [self.accountsService obtainOrCreateActiveAccount];
    NSArray *ignoringProperties = @[NSStringFromSelector(@selector(tokens))];
    AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
    
    if (words) {
      [self.accountsService accountBackedUp:account];
    }
    
    NetworkPlainObject *mainnetNetwork = [account networkForNetworkType:BlockchainNetworkTypeMainnet];
    [self.blockchainNetworkService selectNetwork:mainnetNetwork inAccount:account];
  }];
}

@end
