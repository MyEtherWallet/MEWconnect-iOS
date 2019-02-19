//
//  RestorePrepareRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

#import "RestorePrepareRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface RestorePrepareRouter : NSObject <RestorePrepareRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
