//
//  UIView+LockFrame.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+LockFrame.h"

const char * const kRuntimeLockFrameStorageKey = "kRuntimeLockFrameStorageKey";

@implementation UIView (LockFrame)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    
    SEL originalSelector = @selector(setFrame:);
    SEL swizzledSelector = @selector(swizzledSetFrame:);
    
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

- (void) swizzledSetFrame:(CGRect)frame {
  if (!self.lockFrame) {
    [self swizzledSetFrame:frame];
  }
}

- (BOOL)lockFrame {
  return [objc_getAssociatedObject(self, kRuntimeLockFrameStorageKey) boolValue];
}

- (void)setLockFrame:(BOOL)lockFrame {
  objc_setAssociatedObject(self, kRuntimeLockFrameStorageKey, @(lockFrame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
