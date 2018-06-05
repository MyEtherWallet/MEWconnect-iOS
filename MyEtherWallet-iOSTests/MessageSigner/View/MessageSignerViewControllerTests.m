//
//  MessageSignerViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "MessageSignerViewController.h"

#import "MessageSignerViewOutput.h"

@interface MessageSignerViewControllerTests : XCTestCase

@property (nonatomic, strong) MessageSignerViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation MessageSignerViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[MessageSignerViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(MessageSignerViewOutput));

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

#pragma mark - MessageSignerViewInput tests

@end
