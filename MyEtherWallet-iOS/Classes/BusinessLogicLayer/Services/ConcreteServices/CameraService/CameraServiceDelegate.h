//
//  CameraServiceDelegate.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol CameraService;

@protocol CameraServiceDelegate <NSObject>
- (void) cameraServiceDidStartReading:(id <CameraService>)cameraService;
- (void) cameraServiceDidStopReading:(id <CameraService>)cameraService;
- (void) cameraService:(id <CameraService>)cameraService didScanQRCode:(NSString *)QRCode;
@end
