//
//  QRScannerInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import AudioToolbox.AudioServices;
@import libextobjc.EXTScope;

#import "QRScannerInteractor.h"

#import "QRScannerInteractorOutput.h"

#import "CameraService.h"
#import "CameraServiceDelegate.h"
#import "MEWConnectFacade.h"
#import "MEWConnectFacadeConstants.h"

static NSTimeInterval kQRScannerInteractorAutocloseInterval = 2.0;

@implementation QRScannerInteractor {
  NSTimer *_closeTimer;
}

#pragma mark - QRScannerInteractorInput

- (void)checkAccess {
  @weakify(self);
  [self.cameraService isHaveAccessWithCompletion:^(BOOL granted) {
    @strongify(self);
    if (granted) {
      [self.output accessGranted];
    } else {
      [self.output accessNotGranted];
    }
  }];
}

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

- (void) cancelAutocloseIfNeeded {
  [_closeTimer invalidate];
  _closeTimer = nil;
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
  [_closeTimer invalidate];
  _closeTimer = [NSTimer timerWithTimeInterval:kQRScannerInteractorAutocloseInterval target:self selector:@selector(_autoclose:) userInfo:nil repeats:NO];
  [[NSRunLoop mainRunLoop] addTimer:_closeTimer forMode:NSRunLoopCommonModes];
}

- (void) MEWConnectDidDisconnect:(NSNotification *)notification {
  [self.output mewConnectDidFail];
  [self.cameraService startReading];
}

#pragma mark - Private

- (void) _autoclose:(NSTimer *)timer {
  [self disconnectIfNeeded];
  [self cancelAutocloseIfNeeded];
  [self.output closeScanner];
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
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [cameraService stopReading];
    [self.output mewConnectInProgress];
  }
}

@end
