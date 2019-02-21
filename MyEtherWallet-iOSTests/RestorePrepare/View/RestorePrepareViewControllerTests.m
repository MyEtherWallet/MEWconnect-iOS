//
//  RestorePrepareViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestorePrepareViewController.h"

#import "RestorePrepareViewOutput.h"

@interface RestorePrepareViewControllerTests : XCTestCase

@property (nonatomic, strong) RestorePrepareViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RestorePrepareViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[RestorePrepareViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RestorePrepareViewOutput));

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

#pragma mark - RestorePrepareViewInput tests

@end
