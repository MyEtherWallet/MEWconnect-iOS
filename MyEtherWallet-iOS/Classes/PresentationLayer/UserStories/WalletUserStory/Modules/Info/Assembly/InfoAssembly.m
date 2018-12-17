//
//  InfoAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "TransitioningDelegateFactory.h"
#import "ServiceComponents.h"

#import "InfoAssembly.h"

#import "InfoViewController.h"
#import "InfoInteractor.h"
#import "InfoPresenter.h"
#import "InfoRouter.h"

#import "InfoDataDisplayManager.h"
#import "InfoCellObjectBuilder.h"

@implementation InfoAssembly

- (InfoViewController *)viewInfo {
  return [TyphoonDefinition withClass:[InfoViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterInfo]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterInfo]];
                          [definition injectProperty:@selector(customTransitioningDelegate)
                                                with:[self.transitioningDelegateFactory transitioningDelegateWithType:@(TransitioningDelegateBottomBackgroundedModal) cornerRadius:@16.0]];
                          [definition injectProperty:@selector(modalPresentationStyle)
                                                with:@(UIModalPresentationCustom)];
                          [definition injectProperty:@selector(dataDisplayManager)
                                                with:[self dataDisplayManagerInfo]];
                        }];
}

- (InfoInteractor *)interactorInfo {
  return [TyphoonDefinition withClass:[InfoInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterInfo]];
                          [definition injectProperty:@selector(accountsService)
                                                with:[self.serviceComponents accountsService]];
                          [definition injectProperty:@selector(keychainService)
                                                with:[self.serviceComponents keychainService]];
                        }];
}

- (InfoPresenter *)presenterInfo{
  return [TyphoonDefinition withClass:[InfoPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewInfo]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorInfo]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerInfo]];
                        }];
}

- (InfoRouter *)routerInfo{
  return [TyphoonDefinition withClass:[InfoRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewInfo]];
                        }];
}

- (InfoDataDisplayManager *) dataDisplayManagerInfo {
  return [TyphoonDefinition withClass:[InfoDataDisplayManager class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(cellObjectBuilder)
                                                with:[self cellObjectBuilderInfo]];
                          [definition injectProperty:@selector(delegate)
                                                with:[self viewInfo]];
                        }];
}

- (InfoCellObjectBuilder *) cellObjectBuilderInfo {
  return [TyphoonDefinition withClass:[InfoCellObjectBuilder class]];
}


@end
