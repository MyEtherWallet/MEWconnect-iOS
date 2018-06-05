//
//  RestoreWalletRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RestoreWalletRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface RestoreWalletRouter : NSObject <RestoreWalletRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
