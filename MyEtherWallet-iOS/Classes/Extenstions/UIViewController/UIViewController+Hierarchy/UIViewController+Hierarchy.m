//
//  UIViewController+Hierarchy.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 07/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "UIViewController+Hierarchy.h"

@implementation UIViewController (Hierarchy)

- (__kindof UIViewController *) obtainTopController {
  if ([self isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)self;
    return [[navigationController.viewControllers lastObject] obtainTopController];
  }
  if ([self isKindOfClass:[UITabBarController class]]) {
    UITabBarController *tabController = (UITabBarController *)self;
    return [tabController.selectedViewController obtainTopController];
  }
  if (self.presentedViewController) {
    return [self.presentedViewController obtainTopController];
  }
  return self;
}

- (BOOL) isExistInHierarchy:(Class)viewControllerClass {
  if ([self isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)self;
    for (UIViewController *viewController in navigationController.viewControllers) {
      BOOL exist = [viewController isExistInHierarchy:viewControllerClass];
      if (exist) {
        return exist;
      }
    }
  }
  if ([self isKindOfClass:[UITabBarController class]]) {
    UITabBarController *tabController = (UITabBarController *)self;
    for (UIViewController *viewController in tabController.viewControllers) {
      BOOL exist = [viewController isExistInHierarchy:viewControllerClass];
      if (exist) {
        return exist;
      }
    }
  }
  if (self.presentedViewController) {
    BOOL exist = [self.presentedViewController isExistInHierarchy:viewControllerClass];
    if (exist) {
      return exist;
    }
  }
  return [self isKindOfClass:viewControllerClass];
}

@end
