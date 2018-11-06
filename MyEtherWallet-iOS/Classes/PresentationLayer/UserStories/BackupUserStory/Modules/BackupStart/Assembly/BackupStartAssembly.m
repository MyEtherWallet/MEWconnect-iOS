//
//  BackupStartAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "ServiceComponents.h"

#import "BackupStartAssembly.h"

#import "BackupStartViewController.h"
#import "BackupStartInteractor.h"
#import "BackupStartPresenter.h"
#import "BackupStartRouter.h"

@implementation BackupStartAssembly

- (BackupStartViewController *)viewBackupStart {
  return [TyphoonDefinition withClass:[BackupStartViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBackupStart]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterBackupStart]];
                        }];
}

- (BackupStartInteractor *)interactorBackupStart {
  return [TyphoonDefinition withClass:[BackupStartInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBackupStart]];
                          [definition injectProperty:@selector(walletService)
                                                with:[self.serviceComponents MEWwallet]];
                        }];
}

- (BackupStartPresenter *)presenterBackupStart{
  return [TyphoonDefinition withClass:[BackupStartPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewBackupStart]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorBackupStart]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerBackupStart]];
                        }];
}

- (BackupStartRouter *)routerBackupStart{
  return [TyphoonDefinition withClass:[BackupStartRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewBackupStart]];
                        }];
}

@end
