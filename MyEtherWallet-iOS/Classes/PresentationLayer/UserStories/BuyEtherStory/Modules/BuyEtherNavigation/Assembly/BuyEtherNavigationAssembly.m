//
//  BuyEtherNavigationAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "TransitioningDelegateFactory.h"

#import "BuyEtherNavigationAssembly.h"

#import "BuyEtherNavigationController.h"
#import "BuyEtherNavigationPresenter.h"
#import "BuyEtherNavigationRouter.h"

@implementation BuyEtherNavigationAssembly

- (BuyEtherNavigationController *)viewBuyEtherNavigation {
  return [TyphoonDefinition withClass:[BuyEtherNavigationController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBuyEtherNavigation]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterBuyEtherNavigation]];
                          [definition injectProperty:@selector(customTransitioningDelegate)
                                                with:[self.transitioningDelegateFactory transitioningDelegateWithType:@(TransitioningDelegateBottomBackgroundedModal) cornerRadius:@16.0]];
                          [definition injectProperty:@selector(modalPresentationStyle)
                                                with:@(UIModalPresentationCustom)];
                        }];
}

- (BuyEtherNavigationPresenter *)presenterBuyEtherNavigation{
  return [TyphoonDefinition withClass:[BuyEtherNavigationPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewBuyEtherNavigation]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerBuyEtherNavigation]];
                        }];
}

- (BuyEtherNavigationRouter *)routerBuyEtherNavigation{
  return [TyphoonDefinition withClass:[BuyEtherNavigationRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewBuyEtherNavigation]];
                        }];
}

@end
