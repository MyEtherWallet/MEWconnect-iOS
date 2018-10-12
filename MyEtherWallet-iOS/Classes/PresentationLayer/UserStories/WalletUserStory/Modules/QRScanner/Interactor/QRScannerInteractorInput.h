//
//  QRScannerInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AVCaptureSession;

@protocol QRScannerInteractorInput <NSObject>
- (void) configure;
- (void) checkAccess;
- (AVCaptureSession *) obtainCaptureSession;
- (void) startReading;
- (void) stopReading;

- (void) disconnectIfNeeded;
- (void) cancelAutocloseIfNeeded;
- (void) subscribe;
- (void) unsubscribe;
@end
