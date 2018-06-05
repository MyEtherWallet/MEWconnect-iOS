//
//  RestoreWalletPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreWalletViewOutput.h"
#import "RestoreWalletInteractorOutput.h"
#import "RestoreWalletModuleInput.h"

@protocol RestoreWalletViewInput;
@protocol RestoreWalletInteractorInput;
@protocol RestoreWalletRouterInput;

@interface RestoreWalletPresenter : NSObject <RestoreWalletModuleInput, RestoreWalletViewOutput, RestoreWalletInteractorOutput>

@property (nonatomic, weak) id<RestoreWalletViewInput> view;
@property (nonatomic, strong) id<RestoreWalletInteractorInput> interactor;
@property (nonatomic, strong) id<RestoreWalletRouterInput> router;

@end
