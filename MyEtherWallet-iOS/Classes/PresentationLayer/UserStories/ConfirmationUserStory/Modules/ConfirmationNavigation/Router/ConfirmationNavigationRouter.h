//
//  ConfirmationNavigationRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmationNavigationRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface ConfirmationNavigationRouter : NSObject <ConfirmationNavigationRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
