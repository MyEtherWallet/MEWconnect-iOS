//
//  QRScannerPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "QRScannerPresenter.h"

#import "QRScannerViewInput.h"
#import "QRScannerInteractorInput.h"
#import "QRScannerRouterInput.h"

@interface QRScannerPresenterTests : XCTestCase

@property (nonatomic, strong) QRScannerPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation QRScannerPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[QRScannerPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(QRScannerInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(QRScannerRouterInput));
    self.mockView = OCMProtocolMock(@protocol(QRScannerViewInput));

    self.presenter.interactor = self.mockInteractor;
    self.presenter.router = self.mockRouter;
    self.presenter.view = self.mockView;
}

- (void)tearDown {
    self.presenter = nil;

    self.mockView = nil;
    self.mockRouter = nil;
    self.mockInteractor = nil;

    [super tearDown];
}

#pragma mark - QRScannerModuleInput tests

#pragma mark - QRScannerViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialStateWithCaptureSession:nil]);
}

#pragma mark - QRScannerInteractorOutput tests

@end
