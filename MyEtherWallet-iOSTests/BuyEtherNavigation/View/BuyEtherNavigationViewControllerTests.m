//
//  BuyEtherNavigationViewControllerTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherNavigationViewController.h"

#import "BuyEtherNavigationViewOutput.h"

@interface BuyEtherNavigationViewControllerTests : XCTestCase

@property (nonatomic, strong) BuyEtherNavigationViewController *controller;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BuyEtherNavigationViewControllerTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.controller = [[BuyEtherNavigationViewController alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BuyEtherNavigationViewOutput));

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

#pragma mark - BuyEtherNavigationViewInput tests

@end
