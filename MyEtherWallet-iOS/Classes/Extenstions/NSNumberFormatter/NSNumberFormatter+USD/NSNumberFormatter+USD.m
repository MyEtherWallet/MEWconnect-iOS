//
//  NSNumberFormatter+USD.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSNumberFormatter+USD.h"

@implementation NSNumberFormatter (USD)
+ (instancetype) usdFormatter {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  formatter.numberStyle = NSNumberFormatterCurrencyStyle;
  formatter.currencyCode = @"USD";
  return formatter;
}
@end
