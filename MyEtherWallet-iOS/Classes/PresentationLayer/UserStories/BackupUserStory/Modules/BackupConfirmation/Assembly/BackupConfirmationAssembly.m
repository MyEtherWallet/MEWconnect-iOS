//
//  BackupConfirmationAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ServiceComponents.h"

#import "BackupConfirmationAssembly.h"

#import "BackupConfirmationViewController.h"
#import "BackupConfirmationInteractor.h"
#import "BackupConfirmationPresenter.h"
#import "BackupConfirmationRouter.h"

@implementation BackupConfirmationAssembly

- (BackupConfirmationViewController *)viewBackupConfirmation {
  return [TyphoonDefinition withClass:[BackupConfirmationViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBackupConfirmation]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterBackupConfirmation]];
                        }];
}

- (BackupConfirmationInteractor *)interactorBackupConfirmation {
  return [TyphoonDefinition withClass:[BackupConfirmationInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBackupConfirmation]];
                          [definition injectProperty:@selector(accountsService)
                                                with:[self.serviceComponents accountsService]];
                          [definition injectProperty:@selector(walletService)
                                                with:[self.serviceComponents MEWwallet]];
                          [definition injectProperty:@selector(securityService)
                                                with:[self.serviceComponents securityService]];
                        }];
}

- (BackupConfirmationPresenter *)presenterBackupConfirmation{
  return [TyphoonDefinition withClass:[BackupConfirmationPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewBackupConfirmation]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorBackupConfirmation]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerBackupConfirmation]];
                        }];
}

- (BackupConfirmationRouter *)routerBackupConfirmation{
  return [TyphoonDefinition withClass:[BackupConfirmationRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewBackupConfirmation]];
                        }];
}

@end
