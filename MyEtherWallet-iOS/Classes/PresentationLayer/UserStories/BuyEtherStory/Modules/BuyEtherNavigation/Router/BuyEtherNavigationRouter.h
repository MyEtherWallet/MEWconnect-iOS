//
//  BuyEtherNavigationRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BuyEtherNavigationRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface BuyEtherNavigationRouter : NSObject <BuyEtherNavigationRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
