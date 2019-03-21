//
//  CALayer+LockZPosition.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/21/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import <objc/runtime.h>

#import "CALayer+LockZPosition.h"

const char * const kRuntimeLockZPositionStorageKey = "kRuntimeLockZPositionStorageKey";

@implementation CALayer (LockZPosition)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    
    SEL originalSelector = @selector(setZPosition:);
    SEL swizzledSelector = @selector(swizzledSetZPosition:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
      class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  });
}

- (void) swizzledSetZPosition:(CGFloat)zPosition {
  if (!self.lockZPosition) {
    [self swizzledSetZPosition:zPosition];
  }
}

- (BOOL) lockZPosition {
  return [objc_getAssociatedObject(self, kRuntimeLockZPositionStorageKey) boolValue];
}

- (void) setLockZPosition:(BOOL)lockZPosition {
  objc_setAssociatedObject(self, kRuntimeLockZPositionStorageKey, @(lockZPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
