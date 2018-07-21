//
//  BuyEtherHistoryAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BuyEtherHistoryAssembly.h"

#import "ServiceComponentsAssembly.h"
#import "FetchedResultsControllerAssembly.h"
#import "PonsomizerAssembly.h"

#import "BuyEtherHistoryViewController.h"
#import "BuyEtherHistoryInteractor.h"
#import "BuyEtherHistoryPresenter.h"
#import "BuyEtherHistoryRouter.h"
#import "BuyEtherHistoryDataDisplayManager.h"
#import "BuyEtherHistoryTableViewAnimator.h"
#import "BuyEtherHistoryCellObjectBuilder.h"

@implementation BuyEtherHistoryAssembly

- (BuyEtherHistoryViewController *) viewBuyEtherHistory {
  return [TyphoonDefinition withClass:[BuyEtherHistoryViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBuyEtherHistory]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterBuyEtherHistory]];
                          [definition injectProperty:@selector(dataDisplayManager)
                                                with:[self dataDisplayManagerBuyEtherHistory]];
                          [definition injectProperty:@selector(tableViewAnimator)
                                                with:[self tableViewAnimatorBuyEtherHistory]];
                        }];
}

- (BuyEtherHistoryInteractor *) interactorBuyEtherHistory {
  return [TyphoonDefinition withClass:[BuyEtherHistoryInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBuyEtherHistory]];
                          [definition injectProperty:@selector(cacheTracker)
                                                with:[self.cacheTrackerAssembly cacheTrackerWithDelegate:[self interactorBuyEtherHistory]]];
                          [definition injectProperty:@selector(simplexService)
                                                with:[self.serviceComponents simplexService]];
                          [definition injectProperty:@selector(ponsomizer)
                                                with:[self.ponsomizerAssembly ponsomizer]];
                        }];
}

- (BuyEtherHistoryPresenter *) presenterBuyEtherHistory{
  return [TyphoonDefinition withClass:[BuyEtherHistoryPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewBuyEtherHistory]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorBuyEtherHistory]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerBuyEtherHistory]];
                        }];
}

- (BuyEtherHistoryRouter *) routerBuyEtherHistory{
  return [TyphoonDefinition withClass:[BuyEtherHistoryRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewBuyEtherHistory]];
                        }];
}

- (BuyEtherHistoryDataDisplayManager *) dataDisplayManagerBuyEtherHistory {
  return [TyphoonDefinition withClass:[BuyEtherHistoryDataDisplayManager class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(cellObjectBuilder)
                                                with:[self cellObjectBuilderBuyEtherHistory]];
                        }];
}

- (BuyEtherHistoryTableViewAnimator *) tableViewAnimatorBuyEtherHistory {
  return [TyphoonDefinition withClass:[BuyEtherHistoryTableViewAnimator class]];
}

- (BuyEtherHistoryCellObjectBuilder *) cellObjectBuilderBuyEtherHistory {
  return [TyphoonDefinition withClass:[BuyEtherHistoryCellObjectBuilder class]];
}

@end
