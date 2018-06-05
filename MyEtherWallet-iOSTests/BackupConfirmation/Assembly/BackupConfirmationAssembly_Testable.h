//
//  BackupConfirmationAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationAssembly.h"

@class BackupConfirmationViewController;
@class BackupConfirmationInteractor;
@class BackupConfirmationPresenter;
@class BackupConfirmationRouter;

@interface BackupConfirmationAssembly ()

- (BackupConfirmationViewController *)viewBackupConfirmation;
- (BackupConfirmationPresenter *)presenterBackupConfirmation;
- (BackupConfirmationInteractor *)interactorBackupConfirmation;
- (BackupConfirmationRouter *)routerBackupConfirmation;

@end
