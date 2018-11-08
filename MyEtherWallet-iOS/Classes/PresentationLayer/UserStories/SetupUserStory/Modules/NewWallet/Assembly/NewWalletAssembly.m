//
//  NewWalletAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ServiceComponents.h"
#import "PonsomizerAssembly.h"

#import "NewWalletAssembly.h"

#import "NewWalletViewController.h"
#import "NewWalletInteractor.h"
#import "NewWalletPresenter.h"
#import "NewWalletRouter.h"

@implementation NewWalletAssembly

- (NewWalletViewController *) viewNewWallet {
  return [TyphoonDefinition withClass:[NewWalletViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterNewWallet]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterNewWallet]];
                        }];
}

- (NewWalletInteractor *) interactorNewWallet {
  return [TyphoonDefinition withClass:[NewWalletInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterNewWallet]];
                          [definition injectProperty:@selector(blockchainNetworkService)
                                                with:[self.serviceComponents blockchainNetworkService]];
                          [definition injectProperty:@selector(accountsService)
                                                with:[self.serviceComponents accountsService]];
                          [definition injectProperty:@selector(keychainService)
                                                with:[self.serviceComponents keychainService]];
                          [definition injectProperty:@selector(ponsomizer)
                                                with:[self.ponsomizerAssembly ponsomizer]];
                          [definition injectProperty:@selector(connectFacade)
                                                with:[self.serviceComponents MEWConnectFacade]];
                          [definition injectProperty:@selector(mewWallet)
                                                with:[self.serviceComponents MEWwallet]];
                        }];
}

- (NewWalletPresenter *) presenterNewWallet{
  return [TyphoonDefinition withClass:[NewWalletPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewNewWallet]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorNewWallet]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerNewWallet]];
                        }];
}

- (NewWalletRouter *) routerNewWallet{
  return [TyphoonDefinition withClass:[NewWalletRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewNewWallet]];
                        }];
}

@end
