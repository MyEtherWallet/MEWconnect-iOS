//
//  AboutViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "AboutViewController.h"

#import "AboutViewOutput.h"

@interface AboutViewControllerTests : XCTestCase

@property (nonatomic, strong) AboutViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation AboutViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[AboutViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(AboutViewOutput));

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

#pragma mark - AboutViewInput tests

@end
