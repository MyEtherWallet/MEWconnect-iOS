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

static NSInteger const kMEWTokensCountTokensRangeSize = 32;
static NSInteger const kMEWTokensIsNameSize           = 1;
static NSInteger const kMEWTokensIsWebsiteSize        = 1;
static NSInteger const kMEWTokensIsEmailSize          = 1;

static NSInteger const kMEWTokensSymbolSize           = 16;
static NSInteger const kMEWTokensAddrSize             = 20;
static NSInteger const kMEWTokensDecimalsSize         = 1;
static NSInteger const kMEWTokensBalanceSize          = 32;
static NSInteger const kMEWTokensNameSize             = 16;
static NSInteger const kMEWTokensWebsiteSize          = 32;
static NSInteger const kMEWTokensEmailSize            = 32;

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
    offset -= [self _sizeHex:kMEWTokensCountTokensRangeSize];
    NSRange countTokensRange = NSMakeRange(offset, [self _sizeHex:kMEWTokensCountTokensRangeSize]);
    if (!NSEqualRanges(NSIntersectionRange(workRange, countTokensRange), countTokensRange)) {
      return @[];
    }
    NSString *countTokensStr = [self substringWithRange:countTokensRange];
    countTokens = [countTokensStr parseHexUInt];
  }
  offset -= [self _sizeHex:kMEWTokensIsNameSize];
  NSString *isNameStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:kMEWTokensIsNameSize])];
  BOOL isName = [isNameStr boolValue];
  offset -= [self _sizeHex:kMEWTokensIsWebsiteSize];
  NSString *isWebsiteStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:kMEWTokensIsWebsiteSize])];
  BOOL isWebsite = [isWebsiteStr boolValue];
  offset -= [self _sizeHex:kMEWTokensIsEmailSize];
  NSString *isEmailStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:kMEWTokensIsEmailSize])];
  BOOL isEmail = [isEmailStr boolValue];
  
  for (NSUInteger i = 0; i < countTokens; ++i) {
    NSMutableDictionary *token = [[NSMutableDictionary alloc] init];
    { //balance
      NSUInteger balanceOffset = offset - [self _sizeHex:kMEWTokensSymbolSize + kMEWTokensAddrSize + kMEWTokensDecimalsSize + kMEWTokensBalanceSize];
      NSString *balanceStr = [self substringWithRange:NSMakeRange(balanceOffset, [self _sizeHex:kMEWTokensBalanceSize])];
      NSDecimalNumber *balance = [balanceStr decimalNumberFromHexRepresentation];
      if ([balance compare:[NSDecimalNumber zero]] == NSOrderedDescending) {
        token[@"balance"] = balance;
      } else {
        offset -= [self _sizeHex:kMEWTokensSymbolSize + kMEWTokensAddrSize + kMEWTokensDecimalsSize + kMEWTokensBalanceSize];
        if (isName) { offset -= [self _sizeHex:kMEWTokensNameSize]; }
        if (isWebsite) { offset -= [self _sizeHex:kMEWTokensWebsiteSize]; }
        if (isEmail) { offset -= [self _sizeHex:kMEWTokensEmailSize]; }
        continue;
      }
    }
    { //symbol
      offset -= [self _sizeHex:kMEWTokensSymbolSize];
      NSString *symbolStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:kMEWTokensSymbolSize])];
      token[@"symbol"] = [symbolStr parseHexString];
    }
    { //addr
      offset -= [self _sizeHex:kMEWTokensAddrSize];
      NSString *addrStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:kMEWTokensAddrSize])];
      token[@"addr"] = [@"0x" stringByAppendingString:addrStr];
    }
    { //decimal
      offset -= [self _sizeHex:kMEWTokensDecimalsSize];
      NSString *decimalStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:kMEWTokensDecimalsSize])];
      token[@"decimals"] = @([decimalStr parseHexUInt]);
    }
    { //balance
      offset -= [self _sizeHex:kMEWTokensBalanceSize];
    }
    if (isName) {
      offset -= [self _sizeHex:kMEWTokensNameSize];
      NSString *nameStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:kMEWTokensNameSize])];
      token[@"name"] = [nameStr parseHexString];
    }
    if (isWebsite) {
      offset -= [self _sizeHex:kMEWTokensWebsiteSize];
      NSString *webSiteStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:kMEWTokensWebsiteSize])];
      token[@"website"] = [webSiteStr parseHexString];
    }
    if (isEmail) {
      offset -= [self _sizeHex:kMEWTokensEmailSize];
      NSString *emailStr = [self substringWithRange:NSMakeRange(offset, [self _sizeHex:kMEWTokensEmailSize])];
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
