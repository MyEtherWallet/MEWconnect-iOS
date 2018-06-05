//
//  BackupStartViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupStartViewController.h"

#import "BackupStartViewOutput.h"

@interface BackupStartViewControllerTests : XCTestCase

@property (nonatomic, strong) BackupStartViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BackupStartViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[BackupStartViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BackupStartViewOutput));

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

#pragma mark - BackupStartViewInput tests

@end
