//
//  CameraService.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol CameraServiceDelegate;

@protocol CameraService <NSObject>
@property (nonatomic, weak) id <CameraServiceDelegate> delegate;
- (AVCaptureSession *) obtainSession;
- (void) startReading;
- (void) pauseReading;
- (void) stopReading;
@end
