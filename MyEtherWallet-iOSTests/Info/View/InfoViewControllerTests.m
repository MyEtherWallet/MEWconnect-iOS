//
//  InfoViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "InfoViewController.h"

#import "InfoViewOutput.h"

@interface InfoViewControllerTests : XCTestCase

@property (nonatomic, strong) InfoViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation InfoViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[InfoViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(InfoViewOutput));

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

#pragma mark - InfoViewInput tests

@end
