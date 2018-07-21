//
//  BuyEtherWebPresenter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherWebViewOutput.h"
#import "BuyEtherWebInteractorOutput.h"
#import "BuyEtherWebModuleInput.h"

@protocol BuyEtherWebViewInput;
@protocol BuyEtherWebInteractorInput;
@protocol BuyEtherWebRouterInput;

@interface BuyEtherWebPresenter : NSObject <BuyEtherWebModuleInput, BuyEtherWebViewOutput, BuyEtherWebInteractorOutput>

@property (nonatomic, weak) id<BuyEtherWebViewInput> view;
@property (nonatomic, strong) id<BuyEtherWebInteractorInput> interactor;
@property (nonatomic, strong) id<BuyEtherWebRouterInput> router;

@end
