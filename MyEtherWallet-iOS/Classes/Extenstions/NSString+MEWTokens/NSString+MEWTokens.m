//
//  NSString+MEWTokens.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSString+MEWTokens.h"
#import "NSString+Hex.h"
#import "NSString+HexNSDecimalNumber.h"

@implementation NSString (MEWTokens)

- (NSArray *) decodeMEWTokens {
  NSMutableArray *tokens = [[NSMutableArray alloc] init];
  //Work range
  NSRange workRange = NSMakeRange(0, 0);
  if ([self hasPrefix:@"0x"]) {
    workRange.location += 2;
  }
  NSRange endRange = [self rangeOfString:@"1" options:NSBackwardsSearch];
  if (endRange.location == NSNotFound) {
    return @[];
  }
  workRange.length = endRange.location - workRange.location - 1;
  NSUInteger offset = NSMaxRange(workRange);
  
  NSUInteger countTokens = 0;
  { //Count tokens
    offset -= [self _sizeHex:32];
    NSRange countTokensRange = NSMakeRange(offset, [self _sizeHex:32]);
    if (!NSEqualRanges(NSIntersectionRange(workRange, countTokensRange), countTokensRange)) {
      return @[];
    }
    NSString *countTokensStr = [self substringWithRange:countTokensRange];
    countTokens = [countTokensStr parseHexUInt];
  }
  offset -= [self _sizeHex:1];
  NSString *isNameStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:1])];
  BOOL isName = [isNameStr boolValue];
  offset -= [self _sizeHex:1];
  NSString *isWebsiteStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:1])];
  BOOL isWebsite = [isWebsiteStr boolValue];
  offset -= [self _sizeHex:1];
  NSString *isEmailStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:1])];
  BOOL isEmail = [isEmailStr boolValue];
  
  for (NSUInteger i = 0; i < countTokens; ++i) {
    NSMutableDictionary *token = [[NSMutableDictionary alloc] init];
    { //balance
      NSUInteger balanceOffset = offset - [self _sizeHex:16+20+8+32];
      NSString *balanceStr = [self substringWithRange:NSMakeRange(balanceOffset, [self _sizeHex:32])];
      NSDecimalNumber *balance = [balanceStr decimalNumberFromHexRepresentation];
      if ([balance compare:[NSDecimalNumber zero]] == NSOrderedDescending) {
        token[@"balance"] = balance;
      } else {
        offset -= [self _sizeHex:16+20+8+32];
        if (isName) { offset -= [self _sizeHex:16]; }
        if (isWebsite) { offset -= [self _sizeHex:32]; }
        if (isEmail) { offset -= [self _sizeHex:32]; }
        continue;
      }
    }
    { //symbol
      offset -= [self _sizeHex:16];
      NSString *symbolStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:16])];
      token[@"symbol"] = [symbolStr parseHexString];
    }
    { //addr
      offset -= [self _sizeHex:20];
      NSString *addrStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:20])];
      token[@"addr"] = [@"0x" stringByAppendingString:addrStr];
    }
    { //decimal
      offset -= [self _sizeHex:8];
      NSString *decimalStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:8])];
      token[@"decimals"] = @([decimalStr parseHexUInt]);
    }
    { //balance
      offset -= [self _sizeHex:32];
    }
    if (isName) {
      offset -= [self _sizeHex:16];
      NSString *nameStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:16])];
      token[@"name"] = [nameStr parseHexString];
    }
    if (isWebsite) {
      offset -= [self _sizeHex:32];
      NSString *webSiteStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:32])];
      token[@"website"] = [webSiteStr parseHexString];
    }
    if (isEmail) {
      offset -= [self _sizeHex:32];
      NSString *emailStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:32])];
      token[@"email"] = [emailStr parseHexString];
    }
    [tokens addObject:[token copy]];
  }
  return tokens;
}

- (NSInteger) _sizeHex:(NSInteger)bytes {
  return bytes * 2;
}
@end
