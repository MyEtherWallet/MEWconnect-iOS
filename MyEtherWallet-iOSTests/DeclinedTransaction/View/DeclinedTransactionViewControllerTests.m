//
//  DeclinedTransactionViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "DeclinedTransactionViewController.h"

#import "DeclinedTransactionViewOutput.h"

@interface DeclinedTransactionViewControllerTests : XCTestCase

@property (nonatomic, strong) DeclinedTransactionViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation DeclinedTransactionViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[DeclinedTransactionViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(DeclinedTransactionViewOutput));

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

#pragma mark - DeclinedTransactionViewInput tests

@end
