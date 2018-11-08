//
//  RestoreSeedAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import ViperMcFlurryX;

#import "RestoreSeedAssembly.h"

#import "ServiceComponents.h"
#import "ValidatorComponents.h"

#import "RestoreSeedViewController.h"
#import "RestoreSeedInteractor.h"
#import "RestoreSeedPresenter.h"
#import "RestoreSeedRouter.h"

@implementation RestoreSeedAssembly

- (RestoreSeedViewController *)viewRestoreSeed {
  return [TyphoonDefinition withClass:[RestoreSeedViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterRestoreSeed]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterRestoreSeed]];
                        }];
}

- (RestoreSeedInteractor *)interactorRestoreSeed {
  return [TyphoonDefinition withClass:[RestoreSeedInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterRestoreSeed]];
                          [definition injectProperty:@selector(walletService)
                                                with:[self.serviceComponents MEWwallet]];
                          [definition injectProperty:@selector(mnemonicsValidator)
                                                with:[self.validatorComponents mnemonicsValidator]];
                        }];
}

- (RestoreSeedPresenter *)presenterRestoreSeed{
  return [TyphoonDefinition withClass:[RestoreSeedPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewRestoreSeed]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorRestoreSeed]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerRestoreSeed]];
                        }];
}

- (RestoreSeedRouter *)routerRestoreSeed{
  return [TyphoonDefinition withClass:[RestoreSeedRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewRestoreSeed]];
                        }];
}

@end
