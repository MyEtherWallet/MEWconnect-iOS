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

#import "ApplicationConstants.h"
#import "NSCharacterSet+WNS.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "MasterTokenPlainObject.h"

@interface RestoreSeedInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@property (nonatomic, strong) NSString *password;
@end

@implementation RestoreSeedInteractor {
  NSCharacterSet *_separatorCharactorSet;
  NSArray <NSString *> *_words;
}

#pragma mark - RestoreSeedInteractorInput

- (void) configureWithAccount:(AccountPlainObject *)account password:(NSString *)password {
  self.account = account;
  self.password = password;
  _separatorCharactorSet = [NSCharacterSet whitespaceAndSpaceAndNewlineCharacterSet];
}

- (void) checkMnemonics:(NSString *)mnemonics {
  NSArray <NSString *> *words = [mnemonics componentsSeparatedByCharactersInSet:_separatorCharactorSet];
  words = [words filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.length > 0"]];
  if ([words count] >= kMnemonicsWordsMinLength) {
    _words = [words valueForKey:@"lowercaseString"];
    [self.output allowRestore];
  } else {
    _words = nil;
    [self.output disallowRestore];
  }
}

- (void) tryRestore {
  //Check words
  if (!_words) {
    [self.output restoreNotPossible];
    return;
  }
  //Checking that words is subset of BIP39
  NSArray *allwords = [self.walletService obtainBIP32Words];
  NSSet *allWordsSet = [NSSet setWithArray:allwords];
  NSSet *mnemonicsWordsSet = [NSSet setWithArray:_words];
  if (![mnemonicsWordsSet isSubsetOfSet:allWordsSet]) {
    [self.output restoreNotPossible];
    return;
  }
  
  NetworkPlainObject *network = [self.account.networks anyObject];
  
  if (![self.walletService validateSeedWithWords:_words withNetwork:network]) {
    [self.output invalidMnemonics];
    return;
  }
  
  [self.walletService createWalletWithPassword:self.password mnemonicWords:_words account:self.account];
  [self.output validMnemonicsWithPassword:self.password];
}

@end
