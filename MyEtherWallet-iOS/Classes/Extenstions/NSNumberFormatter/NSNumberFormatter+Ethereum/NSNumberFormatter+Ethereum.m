//
//  NSNumberFormatter+Ethereum.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSNumberFormatter+Ethereum.h"

@implementation NSNumberFormatter (Ethereum)

+ (instancetype)ethereumFormatterWithNetwork:(BlockchainNetworkType)network {
  return [self ethereumFormatterWithCurrencySymbol:NSStringCurrencySymbolFromBlockchainNetworkType(network)];
}

+ (instancetype)ethereumFormatterWithCurrencySymbol:(NSString *)currencySymbol {
  NSNumberFormatter *ethereumFormatter  = [[NSNumberFormatter alloc] init];
  ethereumFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
  ethereumFormatter.currencyDecimalSeparator = @".";
  ethereumFormatter.currencySymbol = currencySymbol;
  //Move currency symbol to the end
  NSRange currencySymbolRange = [ethereumFormatter.positiveFormat rangeOfString:@"¤"];
  if (currencySymbolRange.location == 0) {
    NSMutableString *positiveFormat = [ethereumFormatter.positiveFormat mutableCopy];
    [positiveFormat replaceCharactersInRange:currencySymbolRange withString:@""];
    [positiveFormat appendString:@" ¤"];
    ethereumFormatter.positiveFormat = [positiveFormat copy];
  }
  ethereumFormatter.usesSignificantDigits = YES;
  ethereumFormatter.maximumFractionDigits = 18;
  ethereumFormatter.maximumIntegerDigits = 18;
  ethereumFormatter.maximumSignificantDigits = ethereumFormatter.maximumFractionDigits + ethereumFormatter.maximumIntegerDigits;
  ethereumFormatter.currencySymbol = currencySymbol;
  return ethereumFormatter;
}

@end
