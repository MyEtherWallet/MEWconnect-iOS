//
//  TransactionRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TransactionRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface TransactionRouter : NSObject <TransactionRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
