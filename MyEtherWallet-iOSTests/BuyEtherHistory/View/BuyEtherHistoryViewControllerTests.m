//
//  BuyEtherHistoryViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherHistoryViewController.h"

#import "BuyEtherHistoryViewOutput.h"

@interface BuyEtherHistoryViewControllerTests : XCTestCase

@property (nonatomic, strong) BuyEtherHistoryViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BuyEtherHistoryViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[BuyEtherHistoryViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BuyEtherHistoryViewOutput));

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

#pragma mark - BuyEtherHistoryViewInput tests

@end
