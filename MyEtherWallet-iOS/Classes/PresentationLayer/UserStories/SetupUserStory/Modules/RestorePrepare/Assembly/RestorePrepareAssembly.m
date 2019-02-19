//
//  RestorePrepareAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import ViperMcFlurryX;

#import "RestorePrepareAssembly.h"

#import "RestorePrepareViewController.h"
#import "RestorePrepareInteractor.h"
#import "RestorePreparePresenter.h"
#import "RestorePrepareRouter.h"

@implementation RestorePrepareAssembly

- (RestorePrepareViewController *)viewRestorePrepare {
    return [TyphoonDefinition withClass:[RestorePrepareViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterRestorePrepare]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterRestorePrepare]];
                          }];
}

- (RestorePrepareInteractor *)interactorRestorePrepare {
    return [TyphoonDefinition withClass:[RestorePrepareInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterRestorePrepare]];
                          }];
}

- (RestorePreparePresenter *)presenterRestorePrepare{
    return [TyphoonDefinition withClass:[RestorePreparePresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewRestorePrepare]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorRestorePrepare]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerRestorePrepare]];
                          }];
}

- (RestorePrepareRouter *)routerRestorePrepare{
    return [TyphoonDefinition withClass:[RestorePrepareRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewRestorePrepare]];
                          }];
}

@end
