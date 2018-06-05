//
//  BackupInfoViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupInfoViewController.h"

#import "BackupInfoViewOutput.h"

@interface BackupInfoViewControllerTests : XCTestCase

@property (nonatomic, strong) BackupInfoViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BackupInfoViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[BackupInfoViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BackupInfoViewOutput));

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

#pragma mark - BackupInfoViewInput tests

@end
