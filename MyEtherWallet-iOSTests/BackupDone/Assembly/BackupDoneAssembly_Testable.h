//
//  BackupDoneAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupDoneAssembly.h"

@class BackupDoneViewController;
@class BackupDoneInteractor;
@class BackupDonePresenter;
@class BackupDoneRouter;

@interface BackupDoneAssembly ()

- (BackupDoneViewController *)viewBackupDone;
- (BackupDonePresenter *)presenterBackupDone;
- (BackupDoneInteractor *)interactorBackupDone;
- (BackupDoneRouter *)routerBackupDone;

@end
