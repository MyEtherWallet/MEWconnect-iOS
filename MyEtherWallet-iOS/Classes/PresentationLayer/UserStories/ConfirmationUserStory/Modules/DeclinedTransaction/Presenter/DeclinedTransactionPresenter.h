//
//  DeclinedTransactionPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "DeclinedTransactionViewOutput.h"
#import "DeclinedTransactionInteractorOutput.h"
#import "DeclinedTransactionModuleInput.h"
#import "ConfirmationStoryModuleOutput.h"

@protocol DeclinedTransactionViewInput;
@protocol DeclinedTransactionInteractorInput;
@protocol DeclinedTransactionRouterInput;

@interface DeclinedTransactionPresenter : NSObject <DeclinedTransactionModuleInput, DeclinedTransactionViewOutput, DeclinedTransactionInteractorOutput>

@property (nonatomic, weak) id <DeclinedTransactionViewInput> view;
@property (nonatomic, strong) id <DeclinedTransactionInteractorInput> interactor;
@property (nonatomic, strong) id <DeclinedTransactionRouterInput> router;
@property (nonatomic, weak) id <ConfirmationStoryModuleOutput> moduleOutput;
@end
