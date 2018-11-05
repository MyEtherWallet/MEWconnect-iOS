//
//  RestoreSeedViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreSeedViewController.h"

#import "RestoreSeedViewOutput.h"

@interface RestoreSeedViewControllerTests : XCTestCase

@property (nonatomic, strong) RestoreSeedViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RestoreSeedViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[RestoreSeedViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RestoreSeedViewOutput));

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

#pragma mark - RestoreSeedViewInput tests

@end
