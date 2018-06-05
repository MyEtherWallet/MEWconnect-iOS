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
  AVCaptureSession *session = [self.interactor obtainCaptureSession];
  [self.view setupInitialStateWithCaptureSession:session];
}

- (void) didTriggerViewWillAppear {
  [self.interactor subscribe];
}

- (void) didTriggerViewDidAppear {
  [self.interactor startReading];
}

- (void)didTriggerViewDidDisappear {
  [self.interactor unsubscribe];
  [self.interactor stopReading];
}

- (void) closeAction {
  [self.interactor disconnectIfNeeded];
  [self.router close];
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

@end
