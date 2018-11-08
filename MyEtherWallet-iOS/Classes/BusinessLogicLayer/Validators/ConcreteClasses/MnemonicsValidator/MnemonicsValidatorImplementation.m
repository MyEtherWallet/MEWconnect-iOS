//
//  MnemonicsValidatorImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 08/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MnemonicsValidatorImplementation.h"

#import "MEWwallet.h"

@implementation MnemonicsValidatorImplementation

- (BOOL)isObjectValidated:(id)object {
  NSArray <NSString *> *words = [self _extractWordsFromObject:object];
  if (!words) {
    return NO;
  }
  
  NSArray *allWords = [self.walletService obtainBIP32Words];
  NSSet *allWordsSet = [NSSet setWithArray:allWords];
  NSSet *mnemonicsWordsSet = [NSSet setWithArray:words];
  
  if (![mnemonicsWordsSet isSubsetOfSet:allWordsSet]) {
    return NO;
  }
  return [self.walletService validateMnemonics:words];
}

- (nullable id)extractValidObject:(id)object {
  if (![self isObjectValidated:object]) {
    return nil;
  }
  return [self _extractWordsFromObject:object];
}

#pragma mark - Private

- (NSArray <NSString *> *) _extractWordsFromObject:(id)object {
  NSArray <NSString *> *words = nil;
  
  if ([object isKindOfClass:[NSString class]]) {
    words = [((NSString *)object) componentsSeparatedByCharactersInSet:self.separatorCharacterSet];
  }
  if ([object isKindOfClass:[NSArray <NSString *> class]]) {
    words = object;
  }
  if (!words) {
    return nil;
  }
  NSPredicate *emptyWordsPredicate = [NSPredicate predicateWithFormat:@"SELF.length > 0"];
  words = [words filteredArrayUsingPredicate:emptyWordsPredicate];
  words = [words valueForKeyPath:@"lowercaseString"];
  if ([words count] % 3 != 0 || [words count] == 0) {
    return nil;
  }
  
  return words;
}

@end
