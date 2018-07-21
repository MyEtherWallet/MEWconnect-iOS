//
//  TransactionPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TransactionViewOutput.h"
#import "TransactionInteractorOutput.h"
#import "TransactionModuleInput.h"
#import "ConfirmationStoryModuleOutput.h"

@protocol TransactionViewInput;
@protocol TransactionInteractorInput;
@protocol TransactionRouterInput;

@interface TransactionPresenter : NSObject <TransactionModuleInput, TransactionViewOutput, TransactionInteractorOutput>

@property (nonatomic, weak) id <TransactionViewInput> view;
@property (nonatomic, strong) id <TransactionInteractorInput> interactor;
@property (nonatomic, strong) id <TransactionRouterInput> router;
@property (nonatomic, weak) id <ConfirmationStoryModuleOutput> moduleOutput;
@end
