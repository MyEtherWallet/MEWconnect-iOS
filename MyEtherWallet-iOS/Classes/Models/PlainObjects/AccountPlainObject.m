//
//  AccountPlainObject.m
//
//

#import "AccountPlainObject.h"

@interface AccountPlainObject ()
@end

@implementation AccountPlainObject

- (NetworkPlainObject *) networkForNetworkType:(BlockchainNetworkType)networkType {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.chainID = %d", networkType];
  return [[self.networks filteredSetUsingPredicate:predicate] anyObject];
}

- (BOOL) isEqualToAccount:(AccountPlainObject *)object {
  if (!object) {
    return NO;
  }
  BOOL equalUID = (!self.uid && !object.uid) || [self.uid isEqualToString:object.uid];
  return equalUID;
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
  return [self.uid hash];
}

@end
