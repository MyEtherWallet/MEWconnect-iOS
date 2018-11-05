//
//  TransitioningDelegateBase.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TransitioningDelegateBase.h"

#import "PresentationControllerFactory.h"

@implementation TransitioningDelegateBase

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(__unused UIViewController *)presented presentingController:(__unused UIViewController *)presenting sourceController:(__unused UIViewController *)source {
  return self.presentingAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(__unused UIViewController *)dismissed {
  return self.dismissingAnimationController;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
  return [self.presentationControllerFactory controllerForPresentationType:self.presentationControllerType
                                                   presentedViewController:presented
                                                  presentingViewController:presenting
                                                      sourceViewController:source
                                                              cornerRadius:@(self.cornerRadius)];
}

@end
