//
//  BackupDonePresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupDoneViewOutput.h"
#import "BackupDoneInteractorOutput.h"
#import "BackupDoneModuleInput.h"

@protocol BackupDoneViewInput;
@protocol BackupDoneInteractorInput;
@protocol BackupDoneRouterInput;

@interface BackupDonePresenter : NSObject <BackupDoneModuleInput, BackupDoneViewOutput, BackupDoneInteractorOutput>

@property (nonatomic, weak) id<BackupDoneViewInput> view;
@property (nonatomic, strong) id<BackupDoneInteractorInput> interactor;
@property (nonatomic, strong) id<BackupDoneRouterInput> router;

@end
