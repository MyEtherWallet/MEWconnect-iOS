//
//  PasswordViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "PasswordViewController.h"

#import "PasswordViewOutput.h"

@interface PasswordViewControllerTests : XCTestCase

@property (nonatomic, strong) PasswordViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation PasswordViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[PasswordViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(PasswordViewOutput));

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

#pragma mark - PasswordViewInput tests

@end
