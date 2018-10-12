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

#import "ApplicationConstants.h"

#import "NSBundle+Version.h"

@implementation QRScannerPresenter {
  BOOL _accessGranted;
  BOOL _viewAppeared;
}

#pragma mark - QRScannerModuleInput

- (void) configureModule {
  [self.interactor configure];
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
  _viewAppeared = YES;
  if (_accessGranted && _viewAppeared) {
    [self.interactor startReading];
  }
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

- (void) contactSupportAction {
  NSString *version = [[NSBundle mainBundle] applicationVersion];
  NSString *subject = [NSString stringWithFormat:@"MEWconnect iOS v.%@ connection issue", version];
  NSArray *recipients = @[kMyEtherWalletSupportEmail];
  [self.view presentMailComposeWithSubject:subject recipients:recipients];
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
  _accessGranted = YES;
  [self.view hideAccessWarning];
  
  AVCaptureSession *session = [self.interactor obtainCaptureSession];
  [self.view updateWithCaptureSession:session];
  
  if (_accessGranted && _viewAppeared) {
    [self.interactor startReading];
  }
}

- (void) accessNotGranted {
  [self.view showAccessWarning];
}

@end
