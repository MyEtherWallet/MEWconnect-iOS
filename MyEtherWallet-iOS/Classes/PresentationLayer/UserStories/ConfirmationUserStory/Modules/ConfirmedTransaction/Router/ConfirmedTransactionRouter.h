//
//  ConfirmedTransactionRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmedTransactionRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface ConfirmedTransactionRouter : NSObject <ConfirmedTransactionRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
