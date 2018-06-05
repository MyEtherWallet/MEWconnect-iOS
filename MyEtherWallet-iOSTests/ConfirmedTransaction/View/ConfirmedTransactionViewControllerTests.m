//
//  ConfirmedTransactionViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmedTransactionViewController.h"

#import "ConfirmedTransactionViewOutput.h"

@interface ConfirmedTransactionViewControllerTests : XCTestCase

@property (nonatomic, strong) ConfirmedTransactionViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ConfirmedTransactionViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[ConfirmedTransactionViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ConfirmedTransactionViewOutput));

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

#pragma mark - ConfirmedTransactionViewInput tests

@end
