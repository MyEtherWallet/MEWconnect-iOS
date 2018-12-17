//
//  BackupWordsAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BackupWordsAssembly.h"

#import "ServiceComponents.h"

#import "BackupWordsViewController.h"
#import "BackupWordsInteractor.h"
#import "BackupWordsPresenter.h"
#import "BackupWordsRouter.h"

@implementation BackupWordsAssembly

- (BackupWordsViewController *)viewBackupWords {
  return [TyphoonDefinition withClass:[BackupWordsViewController class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBackupWords]];
                          [definition injectProperty:@selector(moduleInput)
                                                with:[self presenterBackupWords]];
                        }];
}

- (BackupWordsInteractor *)interactorBackupWords {
  return [TyphoonDefinition withClass:[BackupWordsInteractor class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(output)
                                                with:[self presenterBackupWords]];
                          [definition injectProperty:@selector(securityService)
                                                with:[self.serviceComponents securityService]];
                        }];
}

- (BackupWordsPresenter *)presenterBackupWords{
  return [TyphoonDefinition withClass:[BackupWordsPresenter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(view)
                                                with:[self viewBackupWords]];
                          [definition injectProperty:@selector(interactor)
                                                with:[self interactorBackupWords]];
                          [definition injectProperty:@selector(router)
                                                with:[self routerBackupWords]];
                        }];
}

- (BackupWordsRouter *)routerBackupWords{
  return [TyphoonDefinition withClass:[BackupWordsRouter class]
                        configuration:^(TyphoonDefinition *definition) {
                          [definition injectProperty:@selector(transitionHandler)
                                                with:[self viewBackupWords]];
                        }];
}

@end
