//
//  StartViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "StartViewController.h"

#import "StartViewOutput.h"

@interface StartViewControllerTests : XCTestCase

@property (nonatomic, strong) StartViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation StartViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[StartViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(StartViewOutput));

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

#pragma mark - StartViewInput tests

@end
