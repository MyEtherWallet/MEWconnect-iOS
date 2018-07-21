//
//  BackupInfoAssembly.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "BackupInfoAssembly.h"

#import "BackupInfoViewController.h"
#import "BackupInfoInteractor.h"
#import "BackupInfoPresenter.h"
#import "BackupInfoRouter.h"

@implementation BackupInfoAssembly

- (BackupInfoViewController *)viewBackupInfo {
    return [TyphoonDefinition withClass:[BackupInfoViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterBackupInfo]];
                              [definition injectProperty:@selector(moduleInput)
                                                    with:[self presenterBackupInfo]];
                          }];
}

- (BackupInfoInteractor *)interactorBackupInfo {
    return [TyphoonDefinition withClass:[BackupInfoInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(output)
                                                    with:[self presenterBackupInfo]];
                          }];
}

- (BackupInfoPresenter *)presenterBackupInfo{
    return [TyphoonDefinition withClass:[BackupInfoPresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(view)
                                                    with:[self viewBackupInfo]];
                              [definition injectProperty:@selector(interactor)
                                                    with:[self interactorBackupInfo]];
                              [definition injectProperty:@selector(router)
                                                    with:[self routerBackupInfo]];
                          }];
}

- (BackupInfoRouter *)routerBackupInfo{
    return [TyphoonDefinition withClass:[BackupInfoRouter class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition injectProperty:@selector(transitionHandler)
                                                    with:[self viewBackupInfo]];
                          }];
}

@end
