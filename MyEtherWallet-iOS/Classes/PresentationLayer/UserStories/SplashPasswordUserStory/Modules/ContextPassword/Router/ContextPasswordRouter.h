//
//  ContextPasswordRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ContextPasswordRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface ContextPasswordRouter : NSObject <ContextPasswordRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
