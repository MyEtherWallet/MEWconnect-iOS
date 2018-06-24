//
//  QRScannerInteractorOutput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol QRScannerInteractorOutput <NSObject>
- (void) readingStarted;
- (void) mewConnectDidConnected;
- (void) mewConnectInProgress;
- (void) mewConnectDidFail;
- (void) closeScanner;
- (void) accessGranted;
- (void) accessNotGranted;
@end
