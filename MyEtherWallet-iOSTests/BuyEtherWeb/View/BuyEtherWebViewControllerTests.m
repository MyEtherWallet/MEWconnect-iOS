//
//  BuyEtherWebViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherWebViewController.h"

#import "BuyEtherWebViewOutput.h"

@interface BuyEtherWebViewControllerTests : XCTestCase

@property (nonatomic, strong) BuyEtherWebViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BuyEtherWebViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[BuyEtherWebViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BuyEtherWebViewOutput));

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

#pragma mark - BuyEtherWebViewInput tests

@end
