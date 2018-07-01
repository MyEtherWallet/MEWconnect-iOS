//
//  AccountPlainObject.m
//
//

#import "AccountPlainObject.h"

@interface AccountPlainObject ()
@property (nonatomic, strong) NSDecimalNumber *amount;
@end

@implementation AccountPlainObject
@synthesize amount = _amount;

- (void)setBalance:(NSDecimalNumber *)balance {
  _amount = nil;
  [super setBalance:balance];
}

- (NSDecimalNumber *)balance {
  if (!_amount) {
    NSDecimalNumber *decimals = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:[self.decimals shortValue] isNegative:NO];
    NSDecimalNumber *tokenBalance = [[super balance] decimalNumberByDividingBy:decimals];
    _amount = tokenBalance;
  }
  return _amount;
}

- (BOOL) isEqualToAccount:(AccountPlainObject *)object {
  if (!object) {
    return NO;
  }
  BOOL equalPublicAddress = (!self.publicAddress && !object.publicAddress) || [self.publicAddress isEqualToString:object.publicAddress];
  return equalPublicAddress;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  
  if (![object isKindOfClass:[AccountPlainObject class]]) {
    return NO;
  }
  
  return [self isEqualToAccount:(AccountPlainObject *)object];
}

- (NSUInteger) hash {
  return [self.publicAddress hash];
}
@end
