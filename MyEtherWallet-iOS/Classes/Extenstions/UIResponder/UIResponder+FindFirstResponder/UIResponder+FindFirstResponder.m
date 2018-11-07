//
//  UIResponder+FindFirstResponder.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 07/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "UIResponder+FindFirstResponder.h"
#import "FindFirstResponderProtocol.h"

@implementation UIResponder (FindFirstResponder)

- (nullable UIResponder *) findFirstResponder {
  if ([self isFirstResponder]) {
    return self;
  } else if ([self conformsToProtocol:@protocol(FindFirstResponderProtocol)]) {
    return [((UIResponder <FindFirstResponderProtocol> *)self) providedFirstResponder];
  }
  if ([self isKindOfClass:[UIView class]]) {
    for (UIView *subview in ((UIView *)self).subviews) {
      id responder = [subview findFirstResponder];
      if (responder) {
        return responder;
      }
    }
  } else if ([self isKindOfClass:[UIViewController class]]) {
    if ([self isKindOfClass:[UINavigationController class]]) {
      UINavigationController *navigationController = (UINavigationController *)self;
      for (UIViewController *viewController in navigationController.viewControllers) {
        id responder = [viewController findFirstResponder];
        if (responder) {
          return responder;
        }
      }
    }
    if ([self isKindOfClass:[UITabBarController class]]) {
      UITabBarController *tabController = (UITabBarController *)self;
      for (UIViewController *viewController in tabController.viewControllers) {
        id responder = [viewController findFirstResponder];
        if (responder) {
          return responder;
        }
      }
    }
    if (((UIViewController *)self).presentedViewController) {
      UIViewController *viewController = ((UIViewController *)self).presentedViewController;
      id responder = [viewController findFirstResponder];
      if (responder) {
        return responder;
      }
    }
  }
  return nil;
}

@end
