//
//  StartAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ServiceComponents.h"
#import "ModuleFactoriesAssembly.h"

#import "StartAssembly.h"

#import "StartViewController.h"
#import "StartInteractor.h"
#import "StartPresenter.h"
#import "StartRouter.h"

@implementation StartAssembly

- (StartViewController *)viewStart {
  return [TyphoonDefinition withClass:[StartViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterStart]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterStart]];
                        }];
}

- (StartInteractor *)interactorStart {
  return [TyphoonDefinition withClass:[StartInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterStart]];
                        }];
}

- (StartPresenter *)presenterStart{
  return [TyphoonDefinition withClass:[StartPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewStart]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorStart]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerStart]];
                        }];
}

- (StartRouter *)routerStart{
  return [TyphoonDefinition withClass:[StartRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewStart]];
                          [definition injectProperty:@selector(homeFactory)
                                                with:[self.moduleFactoriesAssembly homeFactory]];
                        }];
}

@end
