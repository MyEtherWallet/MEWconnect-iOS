//
//  ConfirmedTransactionPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmedTransactionViewOutput.h"
#import "ConfirmedTransactionInteractorOutput.h"
#import "ConfirmedTransactionModuleInput.h"
#import "ConfirmationStoryModuleOutput.h"

@protocol ConfirmedTransactionViewInput;
@protocol ConfirmedTransactionInteractorInput;
@protocol ConfirmedTransactionRouterInput;

@interface ConfirmedTransactionPresenter : NSObject <ConfirmedTransactionModuleInput, ConfirmedTransactionViewOutput, ConfirmedTransactionInteractorOutput>

@property (nonatomic, weak) id <ConfirmedTransactionViewInput> view;
@property (nonatomic, strong) id <ConfirmedTransactionInteractorInput> interactor;
@property (nonatomic, strong) id <ConfirmedTransactionRouterInput> router;
@property (nonatomic, weak) id <ConfirmationStoryModuleOutput> moduleOutput;
@end
