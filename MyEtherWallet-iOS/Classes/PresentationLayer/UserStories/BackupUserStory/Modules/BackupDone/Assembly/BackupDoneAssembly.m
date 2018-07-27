//
//  BackupDoneAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BackupDoneAssembly.h"

#import "BackupDoneViewController.h"
#import "BackupDoneInteractor.h"
#import "BackupDonePresenter.h"
#import "BackupDoneRouter.h"

@implementation BackupDoneAssembly

- (BackupDoneViewController *)viewBackupDone {
    return [TyphoonDefinition withClass:[BackupDoneViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterBackupDone]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterBackupDone]];
                          }];
}

- (BackupDoneInteractor *)interactorBackupDone {
    return [TyphoonDefinition withClass:[BackupDoneInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterBackupDone]];
                          }];
}

- (BackupDonePresenter *)presenterBackupDone{
    return [TyphoonDefinition withClass:[BackupDonePresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewBackupDone]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorBackupDone]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerBackupDone]];
                          }];
}

- (BackupDoneRouter *)routerBackupDone{
    return [TyphoonDefinition withClass:[BackupDoneRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewBackupDone]];
                          }];
}

@end
