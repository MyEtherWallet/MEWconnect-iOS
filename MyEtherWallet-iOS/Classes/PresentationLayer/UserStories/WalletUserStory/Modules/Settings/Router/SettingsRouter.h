//
//  SettingsRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SettingsRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface SettingsRouter : NSObject <SettingsRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
