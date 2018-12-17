//
//  AboutAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "AboutAssembly.h"

#import "AboutViewController.h"
#import "AboutInteractor.h"
#import "AboutPresenter.h"
#import "AboutRouter.h"

@implementation AboutAssembly

- (AboutViewController *)viewAbout {
  return [TyphoonDefinition withClass:[AboutViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterAbout]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterAbout]];
                        }];
}

- (AboutInteractor *)interactorAbout {
  return [TyphoonDefinition withClass:[AboutInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterAbout]];
                        }];
}

- (AboutPresenter *)presenterAbout{
  return [TyphoonDefinition withClass:[AboutPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewAbout]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorAbout]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerAbout]];
                        }];
}

- (AboutRouter *)routerAbout{
  return [TyphoonDefinition withClass:[AboutRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewAbout]];
                        }];
}

@end
