//
//  MessageSignerAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ServiceComponents.h"

#import "MessageSignerAssembly.h"

#import "MessageSignerViewController.h"
#import "MessageSignerInteractor.h"
#import "MessageSignerPresenter.h"
#import "MessageSignerRouter.h"

@implementation MessageSignerAssembly

- (MessageSignerViewController *)viewMessageSigner {
  return [TyphoonDefinition withClass:[MessageSignerViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterMessageSigner]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterMessageSigner]];
                        }];
}

- (MessageSignerInteractor *)interactorMessageSigner {
  return [TyphoonDefinition withClass:[MessageSignerInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterMessageSigner]];
                          [definition injectProperty:@selector(walletService)
                                                with:[self.serviceComponents MEWwallet]];
                          [definition injectProperty:@selector(connectFacade)
                                                with:[self.serviceComponents MEWConnectFacade]];
                        }];
}

- (MessageSignerPresenter *)presenterMessageSigner{
  return [TyphoonDefinition withClass:[MessageSignerPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewMessageSigner]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorMessageSigner]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerMessageSigner]];
                        }];
}

- (MessageSignerRouter *)routerMessageSigner{
  return [TyphoonDefinition withClass:[MessageSignerRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewMessageSigner]];
                        }];
}

@end
