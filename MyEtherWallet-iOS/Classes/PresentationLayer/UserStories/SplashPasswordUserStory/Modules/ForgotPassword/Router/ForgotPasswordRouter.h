//
//  ForgotPasswordRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ForgotPasswordRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface ForgotPasswordRouter : NSObject <ForgotPasswordRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
