//
//  BackupConfirmationPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationViewOutput.h"
#import "BackupConfirmationInteractorOutput.h"
#import "BackupConfirmationModuleInput.h"

@protocol BackupConfirmationViewInput;
@protocol BackupConfirmationInteractorInput;
@protocol BackupConfirmationRouterInput;

@interface BackupConfirmationPresenter : NSObject <BackupConfirmationModuleInput, BackupConfirmationViewOutput, BackupConfirmationInteractorOutput>

@property (nonatomic, weak) id<BackupConfirmationViewInput> view;
@property (nonatomic, strong) id<BackupConfirmationInteractorInput> interactor;
@property (nonatomic, strong) id<BackupConfirmationRouterInput> router;

@end
