//
//  ShareViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ShareViewController.h"

#import "ShareViewOutput.h"

@interface ShareViewControllerTests : XCTestCase

@property (nonatomic, strong) ShareViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ShareViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[ShareViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ShareViewOutput));

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

#pragma mark - ShareViewInput tests

@end
