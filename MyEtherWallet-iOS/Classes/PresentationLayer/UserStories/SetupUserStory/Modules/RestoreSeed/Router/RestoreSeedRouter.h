//
//  RestoreSeedRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreSeedRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface RestoreSeedRouter : NSObject <RestoreSeedRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
