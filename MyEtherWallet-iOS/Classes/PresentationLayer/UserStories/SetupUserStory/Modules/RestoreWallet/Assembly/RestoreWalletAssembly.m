//
//  RestoreWalletAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "RestoreWalletAssembly.h"

#import "ServiceComponents.h"
#import "ValidatorComponents.h"

#import "RestoreWalletViewController.h"
#import "RestoreWalletInteractor.h"
#import "RestoreWalletPresenter.h"
#import "RestoreWalletRouter.h"

@implementation RestoreWalletAssembly

- (RestoreWalletViewController *)viewRestoreWallet {
  return [TyphoonDefinition withClass:[RestoreWalletViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterRestoreWallet]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterRestoreWallet]];
                        }];
}

- (RestoreWalletInteractor *)interactorRestoreWallet {
  return [TyphoonDefinition withClass:[RestoreWalletInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterRestoreWallet]];
                          [definition injectProperty:@selector(walletService)
                                                with:[self.serviceComponents MEWwallet]];
                          [definition injectProperty:@selector(mnemonicsValidator)
                                                with:[self.validatorComponents mnemonicsValidator]];
                        }];
}

- (RestoreWalletPresenter *)presenterRestoreWallet{
  return [TyphoonDefinition withClass:[RestoreWalletPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewRestoreWallet]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorRestoreWallet]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerRestoreWallet]];
                        }];
}

- (RestoreWalletRouter *)routerRestoreWallet{
  return [TyphoonDefinition withClass:[RestoreWalletRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewRestoreWallet]];
                        }];
}

@end
