//
//  BackupWordsPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupWordsViewOutput.h"
#import "BackupWordsInteractorOutput.h"
#import "BackupWordsModuleInput.h"

@protocol BackupWordsViewInput;
@protocol BackupWordsInteractorInput;
@protocol BackupWordsRouterInput;

@interface BackupWordsPresenter : NSObject <BackupWordsModuleInput, BackupWordsViewOutput, BackupWordsInteractorOutput>

@property (nonatomic, weak) id<BackupWordsViewInput> view;
@property (nonatomic, strong) id<BackupWordsInteractorInput> interactor;
@property (nonatomic, strong) id<BackupWordsRouterInput> router;

@end
