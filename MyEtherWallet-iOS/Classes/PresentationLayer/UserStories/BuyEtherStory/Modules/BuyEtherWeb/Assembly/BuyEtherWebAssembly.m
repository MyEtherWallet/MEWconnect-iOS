//
//  BuyEtherWebAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BuyEtherWebAssembly.h"

#import "ServiceComponentsAssembly.h"

#import "BuyEtherWebViewController.h"
#import "BuyEtherWebInteractor.h"
#import "BuyEtherWebPresenter.h"
#import "BuyEtherWebRouter.h"

@implementation BuyEtherWebAssembly

- (BuyEtherWebViewController *)viewBuyEtherWeb {
  Class viewClass = [BuyEtherWebViewController class];
  
  return [TyphoonDefinition withClass:viewClass
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBuyEtherWeb]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterBuyEtherWeb]];
                        }];
}

- (BuyEtherWebInteractor *)interactorBuyEtherWeb {
  return [TyphoonDefinition withClass:[BuyEtherWebInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBuyEtherWeb]];
                          [definition injectProperty:@selector(simplexService)
                                                with:[self.serviceComponents simplexService]];
                        }];
}

- (BuyEtherWebPresenter *)presenterBuyEtherWeb{
  return [TyphoonDefinition withClass:[BuyEtherWebPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewBuyEtherWeb]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorBuyEtherWeb]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerBuyEtherWeb]];
                        }];
}

- (BuyEtherWebRouter *)routerBuyEtherWeb{
  return [TyphoonDefinition withClass:[BuyEtherWebRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewBuyEtherWeb]];
                        }];
}

@end
