//
//  AboutRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "AboutRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface AboutRouter : NSObject <AboutRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
