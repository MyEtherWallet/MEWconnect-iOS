//
//  BuyEtherAmountPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherAmountViewOutput.h"
#import "BuyEtherAmountInteractorOutput.h"
#import "BuyEtherAmountModuleInput.h"

@protocol BuyEtherAmountViewInput;
@protocol BuyEtherAmountInteractorInput;
@protocol BuyEtherAmountRouterInput;

@interface BuyEtherAmountPresenter : NSObject <BuyEtherAmountModuleInput, BuyEtherAmountViewOutput, BuyEtherAmountInteractorOutput>

@property (nonatomic, weak) id<BuyEtherAmountViewInput> view;
@property (nonatomic, strong) id<BuyEtherAmountInteractorInput> interactor;
@property (nonatomic, strong) id<BuyEtherAmountRouterInput> router;

@end
