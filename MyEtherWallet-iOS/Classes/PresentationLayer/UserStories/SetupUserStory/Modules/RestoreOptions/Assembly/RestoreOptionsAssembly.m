//
//  RestoreOptionsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import ViperMcFlurryX;

#import "RestoreOptionsAssembly.h"

#import "RestoreOptionsViewController.h"
#import "RestoreOptionsInteractor.h"
#import "RestoreOptionsPresenter.h"
#import "RestoreOptionsRouter.h"
#import "RestoreOptionsDataDisplayManager.h"
#import "RestoreOptionsCellObjectBuilder.h"

@implementation RestoreOptionsAssembly

- (RestoreOptionsViewController *) viewRestoreOptions {
  return [TyphoonDefinition withClass:[RestoreOptionsViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterRestoreOptions]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterRestoreOptions]];
                          [definition injectProperty:@selector(dataDisplayManager)
                                                with:[self dataDisplayManagerRestoreOptions]];
                        }];
}

- (RestoreOptionsInteractor *) interactorRestoreOptions {
  return [TyphoonDefinition withClass:[RestoreOptionsInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterRestoreOptions]];
                        }];
}

- (RestoreOptionsPresenter *) presenterRestoreOptions {
  return [TyphoonDefinition withClass:[RestoreOptionsPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewRestoreOptions]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorRestoreOptions]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerRestoreOptions]];
                        }];
}

- (RestoreOptionsRouter *) routerRestoreOptions {
  return [TyphoonDefinition withClass:[RestoreOptionsRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewRestoreOptions]];
                        }];
}

- (RestoreOptionsDataDisplayManager *) dataDisplayManagerRestoreOptions {
  return [TyphoonDefinition withClass:[RestoreOptionsDataDisplayManager class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(cellObjectBuilder)
                                                with:[self cellObjectBuilderRestoreOptions]];
                          [definition injectProperty:@selector(delegate)
                                                with:[self viewRestoreOptions]];
                        }];
}

- (RestoreOptionsCellObjectBuilder *) cellObjectBuilderRestoreOptions {
  return [TyphoonDefinition withClass:[RestoreOptionsCellObjectBuilder class]];
}

@end
