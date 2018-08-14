//
//  ConfirmationNavigationViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmationNavigationViewController.h"

#import "ConfirmationNavigationViewOutput.h"

@interface ConfirmationNavigationViewControllerTests : XCTestCase

@property (nonatomic, strong) ConfirmationNavigationViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ConfirmationNavigationViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[ConfirmationNavigationViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ConfirmationNavigationViewOutput));

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

#pragma mark - ConfirmationNavigationViewInput tests

@end
