//
//  ConfirmedTransactionAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ConfirmedTransactionAssembly.h"

#import "ConfirmedTransactionViewController.h"
#import "ConfirmedTransactionInteractor.h"
#import "ConfirmedTransactionPresenter.h"
#import "ConfirmedTransactionRouter.h"

@implementation ConfirmedTransactionAssembly

- (ConfirmedTransactionViewController *)viewConfirmedTransaction {
    return [TyphoonDefinition withClass:[ConfirmedTransactionViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterConfirmedTransaction]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterConfirmedTransaction]];
                          }];
}

- (ConfirmedTransactionInteractor *)interactorConfirmedTransaction {
    return [TyphoonDefinition withClass:[ConfirmedTransactionInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterConfirmedTransaction]];
                          }];
}

- (ConfirmedTransactionPresenter *)presenterConfirmedTransaction{
    return [TyphoonDefinition withClass:[ConfirmedTransactionPresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewConfirmedTransaction]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorConfirmedTransaction]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerConfirmedTransaction]];
                          }];
}

- (ConfirmedTransactionRouter *)routerConfirmedTransaction{
    return [TyphoonDefinition withClass:[ConfirmedTransactionRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewConfirmedTransaction]];
                          }];
}

@end
