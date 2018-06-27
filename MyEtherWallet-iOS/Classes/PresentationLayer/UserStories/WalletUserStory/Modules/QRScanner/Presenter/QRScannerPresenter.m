//
//  QRScannerPresenter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "QRScannerPresenter.h"

#import "QRScannerViewInput.h"
#import "QRScannerInteractorInput.h"
#import "QRScannerRouterInput.h"

@implementation QRScannerPresenter

#pragma mark - QRScannerModuleInput

- (void) configureModule {
}

#pragma mark - QRScannerViewOutput

- (void) didTriggerViewReadyEvent {
  [self.interactor checkAccess];
  [self.view setupInitialState];
}

- (void) didTriggerViewWillAppear {
  [self.interactor subscribe];
}

- (void) didTriggerViewDidAppear {
  [self.interactor startReading];
}

- (void) didTriggerViewDidDisappear {
  [self.interactor unsubscribe];
  [self.interactor stopReading];
}

- (void) closeAction {
  [self.interactor disconnectIfNeeded];
  [self.interactor cancelAutocloseIfNeeded];
  [self.router close];
}

- (void) settingsAction {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

#pragma mark - QRScannerInteractorOutput

- (void) mewConnectDidConnected {
  [self.view showSuccess];
}

- (void) mewConnectInProgress {
  [self.view showLoading];
}

- (void) mewConnectDidFail {
  [self.view showError];
}

- (void)readingStarted {
  [self.view animateVideoPreview];
}

- (void) closeScanner {
  [self.router close];
}

- (void) accessGranted {
  [self.view hideAccessWarning];
  
  AVCaptureSession *session = [self.interactor obtainCaptureSession];
  [self.view updateWithCaptureSession:session];
}

- (void) accessNotGranted {
  [self.view showAccessWarning];
}

@end
