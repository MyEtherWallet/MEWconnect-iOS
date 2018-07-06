//
//  NSNumberFormatter+TokenPrice.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSNumberFormatter+TokenPrice.h"

static NSNumberFormatter *tokenUSDFormatter = nil;

@implementation NSNumberFormatter (TokenPrice)
+ (instancetype)tokenUSDFormatter {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    tokenUSDFormatter = [[NSNumberFormatter alloc] init];
    tokenUSDFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    tokenUSDFormatter.currencyDecimalSeparator = @".";
    tokenUSDFormatter.currencySymbol = @"@";
    //Move currency symbol to the begin
    NSRange currencySymbolRange = [tokenUSDFormatter.positiveFormat rangeOfString:@"¤"];
    if (currencySymbolRange.location != 0) {
      NSMutableString *positiveFormat = [tokenUSDFormatter.positiveFormat mutableCopy];
      [positiveFormat replaceCharactersInRange:currencySymbolRange withString:@""];
      [positiveFormat insertString:@"¤" atIndex:0];
      tokenUSDFormatter.positiveFormat = [positiveFormat copy];
    }
    tokenUSDFormatter.maximumFractionDigits = 4;
  });
  return tokenUSDFormatter;
}
@end
