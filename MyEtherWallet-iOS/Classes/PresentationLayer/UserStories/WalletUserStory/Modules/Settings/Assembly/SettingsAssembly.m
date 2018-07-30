//
//  SettingsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "SettingsAssembly.h"

#import "SettingsViewController.h"
#import "SettingsInteractor.h"
#import "SettingsPresenter.h"
#import "SettingsRouter.h"

@implementation SettingsAssembly

- (SettingsViewController *)viewSettings {
    return [TyphoonDefinition withClass:[SettingsViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterSettings]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterSettings]];
                          }];
}

- (SettingsInteractor *)interactorSettings {
    return [TyphoonDefinition withClass:[SettingsInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterSettings]];
                          }];
}

- (SettingsPresenter *)presenterSettings{
    return [TyphoonDefinition withClass:[SettingsPresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewSettings]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorSettings]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerSettings]];
                          }];
}

- (SettingsRouter *)routerSettings{
    return [TyphoonDefinition withClass:[SettingsRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewSettings]];
                          }];
}

@end
