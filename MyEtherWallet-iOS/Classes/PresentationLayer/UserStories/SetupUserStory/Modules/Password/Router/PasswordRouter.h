//
//  PasswordRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "PasswordRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface PasswordRouter : NSObject <PasswordRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
