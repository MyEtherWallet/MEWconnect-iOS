//
//  MasterTokenPlainObject.m
//
//

#import "MasterTokenPlainObject.h"

@implementation MasterTokenPlainObject

- (BOOL) isEqualToMasterToken:(MasterTokenPlainObject *)object {
  if (!object) {
    return NO;
  }
  BOOL equalAddress = (!self.address && !object.address) || [self.address isEqualToString:object.address];
  return equalAddress;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  
  if (![object isKindOfClass:[MasterTokenPlainObject class]]) {
    return NO;
  }
  
  return [self isEqualToMasterToken:(MasterTokenPlainObject *)object];
}

- (NSUInteger) hash {
  return [self.address hash];
}

@end
