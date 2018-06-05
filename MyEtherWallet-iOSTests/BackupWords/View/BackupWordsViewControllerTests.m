//
//  BackupWordsViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupWordsViewController.h"

#import "BackupWordsViewOutput.h"

@interface BackupWordsViewControllerTests : XCTestCase

@property (nonatomic, strong) BackupWordsViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BackupWordsViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[BackupWordsViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BackupWordsViewOutput));

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

#pragma mark - BackupWordsViewInput tests

@end
