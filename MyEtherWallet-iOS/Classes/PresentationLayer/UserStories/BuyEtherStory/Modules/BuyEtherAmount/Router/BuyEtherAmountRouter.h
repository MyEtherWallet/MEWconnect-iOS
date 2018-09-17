//
//  BuyEtherAmountRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherAmountRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface BuyEtherAmountRouter : NSObject <BuyEtherAmountRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
