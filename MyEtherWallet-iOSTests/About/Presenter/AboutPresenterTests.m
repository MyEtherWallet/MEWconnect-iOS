//
//  AboutPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "AboutPresenter.h"

#import "AboutViewInput.h"
#import "AboutInteractorInput.h"
#import "AboutRouterInput.h"

@interface AboutPresenterTests : XCTestCase

@property (nonatomic, strong) AboutPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation AboutPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[AboutPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(AboutInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(AboutRouterInput));
    self.mockView = OCMProtocolMock(@protocol(AboutViewInput));

    self.presenter.interactor = self.mockInteractor;
    self.presenter.router = self.mockRouter;
    self.presenter.view = self.mockView;
}

- (void)tearDown {
    self.presenter = nil;

    self.mockView = nil;
    self.mockRouter = nil;
    self.mockInteractor = nil;

    [super tearDown];
}

#pragma mark - AboutModuleInput tests

#pragma mark - AboutViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - AboutInteractorOutput tests

@end
