//
//  QRScannerRouter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import ViperMcFlurryX;

#import "QRScannerRouter.h"

@implementation QRScannerRouter

#pragma mark - QRScannerRouterInput

- (void) close {
  [self.transitionHandler closeCurrentModule:YES];
}

@end
