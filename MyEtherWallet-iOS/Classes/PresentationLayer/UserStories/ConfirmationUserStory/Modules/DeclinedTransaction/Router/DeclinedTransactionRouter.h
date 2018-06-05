//
//  DeclinedTransactionRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "DeclinedTransactionRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface DeclinedTransactionRouter : NSObject <DeclinedTransactionRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
