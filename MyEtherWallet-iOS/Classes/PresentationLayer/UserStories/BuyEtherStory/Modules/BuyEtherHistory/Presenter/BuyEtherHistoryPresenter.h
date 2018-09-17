//
//  BuyEtherHistoryPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherHistoryViewOutput.h"
#import "BuyEtherHistoryInteractorOutput.h"
#import "BuyEtherHistoryModuleInput.h"

@protocol BuyEtherHistoryViewInput;
@protocol BuyEtherHistoryInteractorInput;
@protocol BuyEtherHistoryRouterInput;

@interface BuyEtherHistoryPresenter : NSObject <BuyEtherHistoryModuleInput, BuyEtherHistoryViewOutput, BuyEtherHistoryInteractorOutput>

@property (nonatomic, weak) id<BuyEtherHistoryViewInput> view;
@property (nonatomic, strong) id<BuyEtherHistoryInteractorInput> interactor;
@property (nonatomic, strong) id<BuyEtherHistoryRouterInput> router;

@end
