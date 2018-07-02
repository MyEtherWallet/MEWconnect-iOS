#import "FiatPriceModelObject.h"
#import "AccountModelObject.h"
#import "TokenModelObject.h"

@interface FiatPriceModelObject ()

// Private interface goes here.

@end

@implementation FiatPriceModelObject
@synthesize fromParent;

- (void)setFromParent:(id)fromParent {
  if (!fromParent) {
    return;
  }
  id targetParent = nil;
  if ([fromParent isKindOfClass:[NSArray class]]) {
    targetParent = [((NSArray *)fromParent) firstObject];
    fromParent = [NSSet setWithArray:fromParent];
  } else if ([fromParent isKindOfClass:[NSSet class]]) {
    targetParent = [((NSSet *)fromParent) anyObject];
  } else {
    targetParent = fromParent;
    fromParent = [NSSet setWithObject:fromParent];
  }
  
  if ([targetParent isKindOfClass:[AccountModelObject class]]) {
    self.fromAccount = fromParent;
  } else if ([targetParent isKindOfClass:[TokenModelObject class]]) {
    self.fromToken = fromParent;
  }
}

@end
