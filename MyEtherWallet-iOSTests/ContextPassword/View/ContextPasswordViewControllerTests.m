//
//  ContextPasswordViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ContextPasswordViewController.h"

#import "ContextPasswordViewOutput.h"

@interface ContextPasswordViewControllerTests : XCTestCase

@property (nonatomic, strong) ContextPasswordViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ContextPasswordViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[ContextPasswordViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ContextPasswordViewOutput));

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

#pragma mark - ContextPasswordViewInput tests

@end
