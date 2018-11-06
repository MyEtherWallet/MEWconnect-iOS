//
//  RestoreWalletInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreWalletInteractor.h"

#import "RestoreWalletInteractorOutput.h"

#import "MEWwallet.h"

#import "ApplicationConstants.h"
#import "NSCharacterSet+WNS.h"

@implementation RestoreWalletInteractor {
  NSCharacterSet *_separatorCharactorSet;
  NSArray <NSString *> *_words;
}

#pragma mark - RestoreWalletInteractorInput

- (void)configurate {
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
  if (_words) {
    NSArray *allwords = [self.walletService obtainBIP32Words];
    NSSet *allWordsSet = [NSSet setWithArray:allwords];
    NSSet *mnemonicsWordsSet = [NSSet setWithArray:_words];
    if ([mnemonicsWordsSet isSubsetOfSet:allWordsSet]) {
      [self.output openPasswordWithWords:[_words copy]];
    } else {
      [self.output restoreNotPossible];
    }
  } else {
    [self.output restoreNotPossible];
  }
}

@end
