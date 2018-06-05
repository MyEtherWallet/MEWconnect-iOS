//
//  ConfirmPasswordViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmPasswordViewController.h"

#import "ConfirmPasswordViewOutput.h"

@interface ConfirmPasswordViewControllerTests : XCTestCase

@property (nonatomic, strong) ConfirmPasswordViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ConfirmPasswordViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[ConfirmPasswordViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ConfirmPasswordViewOutput));

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

#pragma mark - ConfirmPasswordViewInput tests

@end
