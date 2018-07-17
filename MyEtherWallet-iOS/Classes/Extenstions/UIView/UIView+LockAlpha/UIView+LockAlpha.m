//
//  UIView+LockAlpha.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+LockAlpha.h"

const char * const kRuntimeLockAlphaStorageKey = "kRuntimeLockAlphaStorageKey";


@implementation UIView (LockAlpha)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];

    SEL originalSelector = @selector(setAlpha:);
    SEL swizzledSelector = @selector(swizzledSetAlpha:);
    
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

- (void) swizzledSetAlpha:(CGFloat)alpha {
  if (!self.lockAlpha) {
    [self swizzledSetAlpha:alpha];
  }
}

- (BOOL) lockAlpha {
  return [objc_getAssociatedObject(self, kRuntimeLockAlphaStorageKey) boolValue];
}

- (void)setLockAlpha:(BOOL)lockAlpha {
  objc_setAssociatedObject(self, kRuntimeLockAlphaStorageKey, @(lockAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
