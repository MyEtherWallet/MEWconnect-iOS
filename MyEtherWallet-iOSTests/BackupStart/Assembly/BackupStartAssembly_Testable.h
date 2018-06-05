//
//  BackupStartAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupStartAssembly.h"

@class BackupStartViewController;
@class BackupStartInteractor;
@class BackupStartPresenter;
@class BackupStartRouter;

@interface BackupStartAssembly ()

- (BackupStartViewController *)viewBackupStart;
- (BackupStartPresenter *)presenterBackupStart;
- (BackupStartInteractor *)interactorBackupStart;
- (BackupStartRouter *)routerBackupStart;

@end
