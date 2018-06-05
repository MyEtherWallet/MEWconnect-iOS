//
//  SplashPasswordRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface SplashPasswordRouter : NSObject <SplashPasswordRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
