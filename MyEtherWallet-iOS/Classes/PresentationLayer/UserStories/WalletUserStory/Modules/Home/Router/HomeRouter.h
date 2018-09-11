//
//  HomeRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HomeRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface HomeRouter : NSObject <HomeRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;
@property (nonatomic, strong) RamblerViperModuleFactory *transactionFactory;
@property (nonatomic, strong) RamblerViperModuleFactory *messageSignerFactory;
@end
