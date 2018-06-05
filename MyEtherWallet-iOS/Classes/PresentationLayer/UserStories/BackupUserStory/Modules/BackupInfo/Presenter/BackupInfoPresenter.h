//
//  BackupInfoPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupInfoViewOutput.h"
#import "BackupInfoInteractorOutput.h"
#import "BackupInfoModuleInput.h"

@protocol BackupInfoViewInput;
@protocol BackupInfoInteractorInput;
@protocol BackupInfoRouterInput;

@interface BackupInfoPresenter : NSObject <BackupInfoModuleInput, BackupInfoViewOutput, BackupInfoInteractorOutput>

@property (nonatomic, weak) id<BackupInfoViewInput> view;
@property (nonatomic, strong) id<BackupInfoInteractorInput> interactor;
@property (nonatomic, strong) id<BackupInfoRouterInput> router;

@end
