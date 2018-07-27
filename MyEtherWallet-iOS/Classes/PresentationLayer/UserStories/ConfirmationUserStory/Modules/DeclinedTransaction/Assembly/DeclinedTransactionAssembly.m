//
//  DeclinedTransactionAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "DeclinedTransactionAssembly.h"

#import "DeclinedTransactionViewController.h"
#import "DeclinedTransactionInteractor.h"
#import "DeclinedTransactionPresenter.h"
#import "DeclinedTransactionRouter.h"

@implementation DeclinedTransactionAssembly

- (DeclinedTransactionViewController *)viewDeclinedTransaction {
    return [TyphoonDefinition withClass:[DeclinedTransactionViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterDeclinedTransaction]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterDeclinedTransaction]];
                          }];
}

- (DeclinedTransactionInteractor *)interactorDeclinedTransaction {
    return [TyphoonDefinition withClass:[DeclinedTransactionInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterDeclinedTransaction]];
                          }];
}

- (DeclinedTransactionPresenter *)presenterDeclinedTransaction{
    return [TyphoonDefinition withClass:[DeclinedTransactionPresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewDeclinedTransaction]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorDeclinedTransaction]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerDeclinedTransaction]];
                          }];
}

- (DeclinedTransactionRouter *)routerDeclinedTransaction{
    return [TyphoonDefinition withClass:[DeclinedTransactionRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewDeclinedTransaction]];
                          }];
}

@end
