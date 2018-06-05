//
//  QRScannerViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "QRScannerViewController.h"

#import "QRScannerViewOutput.h"

@interface QRScannerViewControllerTests : XCTestCase

@property (nonatomic, strong) QRScannerViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation QRScannerViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[QRScannerViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(QRScannerViewOutput));

    self.controller.output = self.mockOutput;
}

- (void)tearDown {
    self.controller = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - Lifecycle tests

- (void)testThatControllerNotifiesPresenterOnDidLoad {
	// given

	// when
	[self.controller viewDidLoad];

	// then
	OCMVerify([self.mockOutput didTriggerViewReadyEvent]);
}

#pragma mark - UI tests

#pragma mark - QRScannerViewInput tests

@end
