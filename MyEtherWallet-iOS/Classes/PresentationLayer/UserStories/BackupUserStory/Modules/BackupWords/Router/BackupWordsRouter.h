//
//  BackupWordsRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupWordsRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface BackupWordsRouter : NSObject <BackupWordsRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
