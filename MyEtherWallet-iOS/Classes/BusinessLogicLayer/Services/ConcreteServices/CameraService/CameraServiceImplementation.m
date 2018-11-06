//
//  CameraServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import AVFoundation;

#import "CameraServiceImplementation.h"
#import "CameraServiceDelegate.h"

@interface CameraServiceImplementation () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic) BOOL configured;
@property (nonatomic) BOOL pause;

@property (nonatomic) AVMediaType mediaType;
@end

@implementation CameraServiceImplementation
@synthesize delegate = _delegate;

- (instancetype) initWithSession:(AVCaptureSession *)session
           captureMetadataOutput:(AVCaptureMetadataOutput *)metadataOutput
                       mediaType:(AVMediaType)mediaType {
  self = [super init];
  if (self) {
    self.pause = YES;
    self.session = session;
    self.mediaType = mediaType;
    AVCaptureDeviceInput *deviceInput = [self _captureDeviceWithMediaType:mediaType];
    if (deviceInput) {
      [self.session addInput:deviceInput];
      [self.session addOutput:metadataOutput];
      if (mediaType == AVMediaTypeVideo && [[metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
        [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
      }
      dispatch_queue_t queue = dispatch_queue_create("com.myetherwallet.mewconnect.camera.captureMetadataOutput", DISPATCH_QUEUE_SERIAL);
      [metadataOutput setMetadataObjectsDelegate:self queue:queue];
      self.configured = YES;
    }
  }
  return self;
}

- (void) dealloc {
  [self stopReading];
}

#pragma mark - Public

- (void)isHaveAccessWithCompletion:(CameraServiceAccessCompletion)completion {
  AVAuthorizationStatus state = [AVCaptureDevice authorizationStatusForMediaType:self.mediaType];
  switch (state) {
    case AVAuthorizationStatusAuthorized: {
      completion(YES);
      break;
    }
    case AVAuthorizationStatusDenied: {
      completion(NO);
      break;
    }
    case AVAuthorizationStatusNotDetermined: {
      [AVCaptureDevice requestAccessForMediaType:self.mediaType completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(granted);
        });
      }];
      break;
    }
    case AVAuthorizationStatusRestricted: {
      completion(NO);
      break;
    }
      
    default:
      break;
  }
}

- (void) startReading {
  if (self.configured) {
    self.pause = NO;
    if (![self.session isRunning]) {
      [self.session startRunning];
      [self.delegate cameraServiceDidStartReading:self];
    }
  }
}

- (void) pauseReading {
  self.pause = YES;
}

- (void) stopReading {
  if ([self.session isRunning]) {
    [self.session stopRunning];
    [self.delegate cameraServiceDidStopReading:self];
  }
  self.pause = YES;
}

- (AVCaptureSession *)obtainSession {
  return _configured ? _session : nil;
}

#pragma mark - Private

- (AVCaptureDeviceInput *) _captureDeviceWithMediaType:(AVMediaType)type {
  AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:type];
  NSError *error = nil;
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
  if (!input) {
    NSLog(@"%@", [error localizedDescription]);
    return nil;
  }
  if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
    [captureDevice lockForConfiguration:&error];
    if (!error) {
      [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
      [captureDevice setFocusPointOfInterest:CGPointMake(0.5, 0.5)];
      [captureDevice unlockForConfiguration];
    }
  }
  return input;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(__unused AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(__unused AVCaptureConnection *)connection{
  if (self.pause) {
    return;
  }
  if ([metadataObjects count] > 0) {
    AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects firstObject];
    if ([metadataObj.type isEqualToString:AVMetadataObjectTypeQRCode]) {
      NSString *QRCode = [metadataObj stringValue];
      dispatch_sync(dispatch_get_main_queue(), ^{
        [self.delegate cameraService:self didScanQRCode:QRCode];
      });
    }
  }
}

@end
