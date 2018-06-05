//
//  NewWalletViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "NewWalletViewController.h"

#import "NewWalletViewOutput.h"

@interface NewWalletViewControllerTests : XCTestCase

@property (nonatomic, strong) NewWalletViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation NewWalletViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[NewWalletViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(NewWalletViewOutput));

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

#pragma mark - NewWalletViewInput tests

@end
