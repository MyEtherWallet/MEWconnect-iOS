//
//  BackupConfirmationRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface BackupConfirmationRouter : NSObject <BackupConfirmationRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
