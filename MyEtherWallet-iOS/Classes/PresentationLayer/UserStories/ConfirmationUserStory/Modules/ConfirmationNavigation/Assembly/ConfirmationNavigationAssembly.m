//
//  ConfirmationNavigationAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "TransitioningDelegateFactory.h"

#import "ConfirmationNavigationAssembly.h"

#import "ConfirmationNavigationViewController.h"
#import "ConfirmationNavigationPresenter.h"
#import "ConfirmationNavigationRouter.h"

@implementation ConfirmationNavigationAssembly

- (ConfirmationNavigationViewController *)viewConfirmationNavigation {
  return [TyphoonDefinition withClass:[ConfirmationNavigationViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterConfirmationNavigation]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterConfirmationNavigation]];
                          [definition injectProperty:@selector(customTransitioningDelegate)
                                                with:[self.transitioningDelegateFactory transitioningDelegateWithType:@(TransitioningDelegateBottomBackgroundedModal) cornerRadius:@16.0]];
                          [definition injectProperty:@selector(modalPresentationStyle)
                                                with:@(UIModalPresentationCustom)];
                        }];
}

- (ConfirmationNavigationPresenter *)presenterConfirmationNavigation{
  return [TyphoonDefinition withClass:[ConfirmationNavigationPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewConfirmationNavigation]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerConfirmationNavigation]];
                        }];
}

- (ConfirmationNavigationRouter *)routerConfirmationNavigation{
  return [TyphoonDefinition withClass:[ConfirmationNavigationRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewConfirmationNavigation]];
                        }];
}

@end
