//
//  ShareAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "TransitioningDelegateFactory.h"

#import "ShareAssembly.h"

#import "ShareViewController.h"
#import "ShareInteractor.h"
#import "SharePresenter.h"
#import "ShareRouter.h"

@implementation ShareAssembly

- (ShareViewController *)viewShare {
  return [TyphoonDefinition withClass:[ShareViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterShare]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterShare]];
                          [definition injectProperty:@selector(customTransitioningDelegate)
                                                with:[self.transitioningDelegateFactory transitioningDelegateWithType:@(TransitioningDelegateBottomBackgroundedModal) cornerRadius:@16.0]];
                          [definition injectProperty:@selector(modalPresentationStyle)
                                                with:@(UIModalPresentationCustom)];
                        }];
}

- (ShareInteractor *)interactorShare {
  return [TyphoonDefinition withClass:[ShareInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterShare]];
                        }];
}

- (SharePresenter *)presenterShare{
  return [TyphoonDefinition withClass:[SharePresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewShare]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorShare]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerShare]];
                        }];
}

- (ShareRouter *)routerShare{
  return [TyphoonDefinition withClass:[ShareRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewShare]];
                        }];
}

@end
