//
//  BackupWordsAssembly_Testable.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupWordsAssembly.h"

@class BackupWordsViewController;
@class BackupWordsInteractor;
@class BackupWordsPresenter;
@class BackupWordsRouter;

@interface BackupWordsAssembly ()

- (BackupWordsViewController *)viewBackupWords;
- (BackupWordsPresenter *)presenterBackupWords;
- (BackupWordsInteractor *)interactorBackupWords;
- (BackupWordsRouter *)routerBackupWords;

@end
