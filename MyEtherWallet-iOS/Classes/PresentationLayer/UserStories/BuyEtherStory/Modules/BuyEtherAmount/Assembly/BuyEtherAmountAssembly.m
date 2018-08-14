//
//  BuyEtherAmountAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BuyEtherAmountAssembly.h"

#import "ServiceComponentsAssembly.h"

#import "BuyEtherAmountViewController.h"
#import "BuyEtherAmountInteractor.h"
#import "BuyEtherAmountPresenter.h"
#import "BuyEtherAmountRouter.h"

@implementation BuyEtherAmountAssembly

- (BuyEtherAmountViewController *)viewBuyEtherAmount {
  return [TyphoonDefinition withClass:[BuyEtherAmountViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBuyEtherAmount]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterBuyEtherAmount]];
                        }];
}

- (BuyEtherAmountInteractor *)interactorBuyEtherAmount {
  return [TyphoonDefinition withClass:[BuyEtherAmountInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBuyEtherAmount]];
                          [definition injectProperty:@selector(simplexService)
                                                with:[self.serviceComponents simplexService]];
                        }];
}

- (BuyEtherAmountPresenter *)presenterBuyEtherAmount{
  return [TyphoonDefinition withClass:[BuyEtherAmountPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewBuyEtherAmount]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorBuyEtherAmount]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerBuyEtherAmount]];
                        }];
}

- (BuyEtherAmountRouter *)routerBuyEtherAmount{
  return [TyphoonDefinition withClass:[BuyEtherAmountRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewBuyEtherAmount]];
                        }];
}

@end
