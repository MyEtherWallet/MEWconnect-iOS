//
//  BuyEtherHistoryPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherHistoryPresenter.h"

#import "BuyEtherHistoryViewInput.h"
#import "BuyEtherHistoryInteractorInput.h"
#import "BuyEtherHistoryRouterInput.h"

@interface BuyEtherHistoryPresenterTests : XCTestCase

@property (nonatomic, strong) BuyEtherHistoryPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation BuyEtherHistoryPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[BuyEtherHistoryPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(BuyEtherHistoryInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(BuyEtherHistoryRouterInput));
    self.mockView = OCMProtocolMock(@protocol(BuyEtherHistoryViewInput));

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

#pragma mark - BuyEtherHistoryModuleInput tests

#pragma mark - BuyEtherHistoryViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - BuyEtherHistoryInteractorOutput tests

@end
