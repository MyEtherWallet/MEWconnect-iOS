//
//  ConfirmPasswordRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmPasswordRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface ConfirmPasswordRouter : NSObject <ConfirmPasswordRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
