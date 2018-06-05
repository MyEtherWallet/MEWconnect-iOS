//
//  BackupDoneViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupDoneViewController.h"

#import "BackupDoneViewOutput.h"

@interface BackupDoneViewControllerTests : XCTestCase

@property (nonatomic, strong) BackupDoneViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BackupDoneViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[BackupDoneViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BackupDoneViewOutput));

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

#pragma mark - BackupDoneViewInput tests

@end
