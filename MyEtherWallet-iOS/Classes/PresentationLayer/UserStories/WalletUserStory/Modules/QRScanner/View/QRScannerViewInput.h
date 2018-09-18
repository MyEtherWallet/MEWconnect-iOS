//
//  QRScannerViewInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class AVCaptureSession;

@protocol QRScannerViewInput <NSObject>

- (void) setupInitialState;
- (void) updateWithCaptureSession:(AVCaptureSession *)captureSession;
- (void) animateVideoPreview;

- (void) showLoading;
- (void) showError;
- (void) showSuccess;

- (void) hideAccessWarning;
- (void) showAccessWarning;

- (void) presentMailComposeWithSubject:(NSString *)subject recipients:(NSArray <NSString *> *)recipients;
@end
