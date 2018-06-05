//
//  SplashPasswordViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "SplashPasswordViewController.h"

#import "SplashPasswordViewOutput.h"

@interface SplashPasswordViewControllerTests : XCTestCase

@property (nonatomic, strong) SplashPasswordViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation SplashPasswordViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[SplashPasswordViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(SplashPasswordViewOutput));

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

#pragma mark - SplashPasswordViewInput tests

@end
