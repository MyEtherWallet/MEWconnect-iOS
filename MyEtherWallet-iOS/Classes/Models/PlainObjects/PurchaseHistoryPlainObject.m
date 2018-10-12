//
//  PurchaseHistoryPlainObject.m
//
//

#import "PurchaseHistoryPlainObject.h"

@implementation PurchaseHistoryPlainObject

- (BOOL) isEqualToPurchaseHistory:(PurchaseHistoryPlainObject *)purchaseHistory {
  return [self.date isEqualToDate:purchaseHistory.date];
}

- (BOOL) isEqual:(id)object {
  if ([object isKindOfClass:[PurchaseHistoryPlainObject class]]) {
    return [self isEqualToPurchaseHistory:(PurchaseHistoryPlainObject *)object];
  }
  return [super isEqual:object];
}

- (NSUInteger) hash {
  return [self.date hash];
}

@end
