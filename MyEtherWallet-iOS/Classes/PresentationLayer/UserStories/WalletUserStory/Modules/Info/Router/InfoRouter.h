//
//  InfoRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface InfoRouter : NSObject <InfoRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
