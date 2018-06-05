//
//  NewWalletPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NewWalletViewOutput.h"
#import "NewWalletInteractorOutput.h"
#import "NewWalletModuleInput.h"

@protocol NewWalletViewInput;
@protocol NewWalletInteractorInput;
@protocol NewWalletRouterInput;

@interface NewWalletPresenter : NSObject <NewWalletModuleInput, NewWalletViewOutput, NewWalletInteractorOutput>

@property (nonatomic, weak) id<NewWalletViewInput> view;
@property (nonatomic, strong) id<NewWalletInteractorInput> interactor;
@property (nonatomic, strong) id<NewWalletRouterInput> router;

@end
