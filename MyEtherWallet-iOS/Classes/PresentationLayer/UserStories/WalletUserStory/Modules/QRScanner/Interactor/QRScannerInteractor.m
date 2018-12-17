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

static NSString *const kQRScannerInteractorConnectionSuccessSoundName = @"peep_connection_success";
static NSString *const kQRScannerInteractorConnectionStartedSoundName = @"peep_connection_started";
static NSString *const kQRScannerInteractorConnectionFailedSoundName  = @"peep_connection_failed";

static NSString *const kQRScannerInteractorConnectionSoundExtension   = @"caf";

@interface QRScannerInteractor ()
@property (nonatomic) SystemSoundID connectionSuccessSoundID;
@property (nonatomic) SystemSoundID connectionStartedSoundID;
@property (nonatomic) SystemSoundID connectionFailedSoundID;
@end

@implementation QRScannerInteractor {
  NSTimer *_closeTimer;
}

- (void)dealloc {
  [self _unloadSounds];
}

#pragma mark - QRScannerInteractorInput

- (void) configure {
  [self _loadSounds];
}

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

- (void) MEWConnectDidConnect:(__unused NSNotification *)notification {
  [self _playSound:self.connectionSuccessSoundID];
  [self.output mewConnectDidConnected];
  [self.cameraService stopReading];
  [_closeTimer invalidate];
  _closeTimer = [NSTimer timerWithTimeInterval:kQRScannerInteractorAutocloseInterval target:self selector:@selector(_autoclose:) userInfo:nil repeats:NO];
  [[NSRunLoop mainRunLoop] addTimer:_closeTimer forMode:NSRunLoopCommonModes];
}

- (void) MEWConnectDidDisconnect:(__unused NSNotification *)notification {
  [self _playSound:self.connectionFailedSoundID];
  [self.output mewConnectDidFail];
  [self.cameraService startReading];
}

#pragma mark - Private

- (void) _autoclose:(__unused NSTimer *)timer {
  [self disconnectIfNeeded];
  [self cancelAutocloseIfNeeded];
  [self.output closeScanner];
}

- (void) _loadSounds {
  [self _unloadSounds];
  self.connectionSuccessSoundID = [self _loadSound:kQRScannerInteractorConnectionSuccessSoundName extension:kQRScannerInteractorConnectionSoundExtension];
  self.connectionStartedSoundID = [self _loadSound:kQRScannerInteractorConnectionStartedSoundName extension:kQRScannerInteractorConnectionSoundExtension];
  self.connectionFailedSoundID = [self _loadSound:kQRScannerInteractorConnectionFailedSoundName extension:kQRScannerInteractorConnectionSoundExtension];
}

- (void) _unloadSounds {
  [self _unloadSound:self.connectionSuccessSoundID];
  [self _unloadSound:self.connectionStartedSoundID];
  [self _unloadSound:self.connectionFailedSoundID];
  
  self.connectionSuccessSoundID = 0;
  self.connectionStartedSoundID = 0;
  self.connectionFailedSoundID  = 0;
}

- (SystemSoundID) _loadSound:(NSString *)name extension:(NSString *)extension {
  NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name withExtension:extension];
  if (fileURL) {
    SystemSoundID soundID = 0;
    OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(fileURL), &soundID);
    if (status != kAudioServicesNoError) {
      return 0;
    }
    return soundID;
  }
  return 0;
}

- (void) _unloadSound:(SystemSoundID)soundID {
  if (soundID != 0) {
    AudioServicesDisposeSystemSoundID(soundID);
  }
}

- (void) _playSound:(SystemSoundID)soundID {
  if (soundID != 0) {
    AudioServicesPlaySystemSoundWithCompletion(soundID, nil);
  }
}

#pragma mark - CameraServiceDelegate

- (void)cameraServiceDidStartReading:(__unused id<CameraService>)cameraService {
  [self.output readingStarted];
}

- (void)cameraServiceDidStopReading:(__unused id<CameraService>)cameraService {
  
}

- (void)cameraService:(id<CameraService>)cameraService didScanQRCode:(NSString *)QRCode {
  [cameraService pauseReading];
  BOOL result = [self.connectFacade connectWithData:QRCode];
  if (!result) {
    [self.output mewConnectDidFail];
    [cameraService startReading];
  } else {
    [self _playSound:self.connectionStartedSoundID];
#if !DEBUG
    [self _playSound:kSystemSoundID_Vibrate];
#endif
    [cameraService stopReading];
    [self.output mewConnectInProgress];
  }
}

@end
