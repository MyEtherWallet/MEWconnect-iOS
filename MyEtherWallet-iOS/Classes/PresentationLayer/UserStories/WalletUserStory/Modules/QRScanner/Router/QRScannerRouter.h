//
//  QRScannerRouter.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "QRScannerRouterInput.h"

@protocol RamblerViperModuleTransitionHandlerProtocol;

@interface QRScannerRouter : NSObject <QRScannerRouterInput>

@property (nonatomic, weak) id<RamblerViperModuleTransitionHandlerProtocol> transitionHandler;

@end
