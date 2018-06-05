//
//  BackupInfoAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupInfoAssembly.h"

@class BackupInfoViewController;
@class BackupInfoInteractor;
@class BackupInfoPresenter;
@class BackupInfoRouter;

@interface BackupInfoAssembly ()

- (BackupInfoViewController *)viewBackupInfo;
- (BackupInfoPresenter *)presenterBackupInfo;
- (BackupInfoInteractor *)interactorBackupInfo;
- (BackupInfoRouter *)routerBackupInfo;

@end
