//
//  ShareRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ShareRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface ShareRouter : NSObject <ShareRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
