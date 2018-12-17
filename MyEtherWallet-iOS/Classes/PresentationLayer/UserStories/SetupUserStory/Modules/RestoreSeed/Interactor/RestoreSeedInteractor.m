//
//  RestoreSeedInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSeedInteractor.h"

#import "RestoreSeedInteractorOutput.h"

#import "MEWwallet.h"

#import "ObjectValidator.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "MasterTokenPlainObject.h"

@interface RestoreSeedInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@property (nonatomic, strong) NSString *password;
@end

@implementation RestoreSeedInteractor {
  NSString *_mnemonics;
}

#pragma mark - RestoreSeedInteractorInput

- (void) configureWithAccount:(AccountPlainObject *)account password:(NSString *)password {
  self.account = account;
  self.password = password;
}

- (void) checkMnemonics:(NSString *)mnemonics {
  if ([self.mnemonicsValidator isObjectValidated:mnemonics]) {
    _mnemonics = mnemonics;
    [self.output allowRestore];
  } else {
    _mnemonics = nil;
    [self.output disallowRestore];
  }
}

- (void) tryRestore {
  if (![self.mnemonicsValidator isObjectValidated:_mnemonics]) {
    [self.output restoreNotPossible];
    return;
  }
  NSArray <NSString *> *words = [self.mnemonicsValidator extractValidObject:_mnemonics];
  if (!words) {
    [self.output restoreNotPossible];
    return;
  }
  
  NetworkPlainObject *network = [self.account.networks anyObject];
  
  if (![self.walletService validateSeedWithWords:words withNetwork:network]) {
    [self.output invalidMnemonics];
    return;
  }
  
  [self.walletService createWalletWithPassword:self.password mnemonicWords:words account:self.account];
  [self.output validMnemonicsWithPassword:self.password];
}

@end
