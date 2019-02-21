//
//  RestoreOptionsViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreOptionsViewController.h"

#import "RestoreOptionsViewOutput.h"

@interface RestoreOptionsViewControllerTests : XCTestCase

@property (nonatomic, strong) RestoreOptionsViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RestoreOptionsViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[RestoreOptionsViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RestoreOptionsViewOutput));

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

#pragma mark - RestoreOptionsViewInput tests

@end
