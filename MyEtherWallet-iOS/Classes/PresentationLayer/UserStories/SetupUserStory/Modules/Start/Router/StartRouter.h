//
//  StartRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "StartRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface StartRouter : NSObject <StartRouterInput>
@property (nonatomic, weak) id <RamblerViperModuleTransitionHandlerProtocol> transitionHandler;
@property (nonatomic, strong) RamblerViperModuleFactory *homeFactory;
@end
