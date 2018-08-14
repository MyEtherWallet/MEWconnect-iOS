//
//  BuyEtherNavigationPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherNavigationViewOutput.h"
#import "BuyEtherNavigationModuleInput.h"

@protocol BuyEtherNavigationViewInput;
@protocol BuyEtherNavigationInteractorInput;
@protocol BuyEtherNavigationRouterInput;

@interface BuyEtherNavigationPresenter : NSObject <BuyEtherNavigationModuleInput, BuyEtherNavigationViewOutput>

@property (nonatomic, weak) id<BuyEtherNavigationViewInput> view;
@property (nonatomic, strong) id<BuyEtherNavigationRouterInput> router;

@end
