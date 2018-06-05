//
//  MessageSignerRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MessageSignerRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface MessageSignerRouter : NSObject <MessageSignerRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
