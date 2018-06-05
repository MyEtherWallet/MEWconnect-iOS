//
//  TokenPlainObject.m
//
//

#import "TokenPlainObject.h"
#import "NSNumberFormatter+Ethereum.h"

@implementation TokenPlainObject
@synthesize amount = _amount;
@synthesize amountString = _amountString;

#pragma mark - Getter

- (NSDecimalNumber *)amount {
  if (!_amount) {
    NSDecimalNumber *decimals = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:[self.decimals shortValue] isNegative:NO];
    NSDecimalNumber *tokenBalance = [self.balance decimalNumberByDividingBy:decimals];
    _amount = tokenBalance;
  }
  return _amount;
}

- (NSString *)amountString {
  if (!_amountString) {
    NSDecimalNumber *tokenBalance = [self amount];
    NSNumberFormatter *ethereumFormatter = [NSNumberFormatter ethereumFormatterWithCurrencySymbol:self.symbol];
    _amountString = [ethereumFormatter stringFromNumber:tokenBalance];
  }
  return _amountString;
}

@end
