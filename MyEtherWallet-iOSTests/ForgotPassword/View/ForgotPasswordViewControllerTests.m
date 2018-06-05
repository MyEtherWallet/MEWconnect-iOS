//
//  ForgotPasswordViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ForgotPasswordViewController.h"

#import "ForgotPasswordViewOutput.h"

@interface ForgotPasswordViewControllerTests : XCTestCase

@property (nonatomic, strong) ForgotPasswordViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ForgotPasswordViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[ForgotPasswordViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ForgotPasswordViewOutput));

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

#pragma mark - ForgotPasswordViewInput tests

@end
