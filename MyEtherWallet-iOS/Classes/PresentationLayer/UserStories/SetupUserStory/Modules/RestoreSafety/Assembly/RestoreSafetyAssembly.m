//
//  RestoreSafetyAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import ViperMcFlurryX;

#import "RestoreSafetyAssembly.h"

#import "RestoreSafetyViewController.h"
#import "RestoreSafetyInteractor.h"
#import "RestoreSafetyPresenter.h"
#import "RestoreSafetyRouter.h"

@implementation RestoreSafetyAssembly

- (RestoreSafetyViewController *)viewRestoreSafety {
    return [TyphoonDefinition withClass:[RestoreSafetyViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterRestoreSafety]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterRestoreSafety]];
                          }];
}

- (RestoreSafetyInteractor *)interactorRestoreSafety {
    return [TyphoonDefinition withClass:[RestoreSafetyInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterRestoreSafety]];
                          }];
}

- (RestoreSafetyPresenter *)presenterRestoreSafety{
    return [TyphoonDefinition withClass:[RestoreSafetyPresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewRestoreSafety]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorRestoreSafety]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerRestoreSafety]];
                          }];
}

- (RestoreSafetyRouter *)routerRestoreSafety{
    return [TyphoonDefinition withClass:[RestoreSafetyRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewRestoreSafety]];
                          }];
}

@end
