//
//  BuyEtherWebRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherWebRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface BuyEtherWebRouter : NSObject <BuyEtherWebRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
