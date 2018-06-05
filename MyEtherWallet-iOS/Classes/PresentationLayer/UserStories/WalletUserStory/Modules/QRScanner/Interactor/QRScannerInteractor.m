//
//  QRScannerInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "QRScannerInteractor.h"

#import "QRScannerInteractorOutput.h"

#import "CameraService.h"
#import "CameraServiceDelegate.h"
#import "MEWConnectFacade.h"
#import "MEWConnectFacadeConstants.h"

@implementation QRScannerInteractor

#pragma mark - QRScannerInteractorInput

- (AVCaptureSession *) obtainCaptureSession {
  return [self.cameraService obtainSession];
}

- (void)startReading {
  [self.cameraService startReading];
}

- (void)stopReading {
  [self.cameraService stopReading];
}

- (void)disconnectIfNeeded {
  MEWConnectStatus status = [self.connectFacade connectionStatus];
  if (status != MEWConnectStatusConnected) {
    [self.connectFacade disconnect];
  }
}

- (void)subscribe {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidConnect:) name:MEWConnectFacadeDidConnectNotification object:self.connectFacade];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MEWConnectDidDisconnect:) name:MEWConnectFacadeDidDisconnectNotification object:self.connectFacade];
}

- (void)unsubscribe {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void) MEWConnectDidConnect:(NSNotification *)notification {
  [self.output mewConnectDidConnected];
  [self.cameraService stopReading];
}

- (void) MEWConnectDidDisconnect:(NSNotification *)notification {
  [self.output mewConnectDidFail];
  [self.cameraService startReading];
}

#pragma mark - CameraServiceDelegate

- (void)cameraServiceDidStartReading:(id<CameraService>)cameraService {
  [self.output readingStarted];
}

- (void)cameraServiceDidStopReading:(id<CameraService>)cameraService {
  
}

- (void)cameraService:(id<CameraService>)cameraService didScanQRCode:(NSString *)QRCode {
  [cameraService pauseReading];
  BOOL result = [self.connectFacade connectWithData:QRCode];
  if (!result) {
    [self.output mewConnectDidFail];
    [cameraService startReading];
  } else {
    [cameraService stopReading];
    [self.output mewConnectInProgress];
  }
}

@end
