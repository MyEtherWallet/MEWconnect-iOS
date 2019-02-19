//
//  RestoreOptionsRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestoreOptionsRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface RestoreOptionsRouter : NSObject <RestoreOptionsRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
