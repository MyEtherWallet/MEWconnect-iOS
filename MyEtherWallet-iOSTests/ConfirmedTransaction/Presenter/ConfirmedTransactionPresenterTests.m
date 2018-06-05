//
//  ConfirmedTransactionPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmedTransactionPresenter.h"

#import "ConfirmedTransactionViewInput.h"
#import "ConfirmedTransactionInteractorInput.h"
#import "ConfirmedTransactionRouterInput.h"

@interface ConfirmedTransactionPresenterTests : XCTestCase

@property (nonatomic, strong) ConfirmedTransactionPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation ConfirmedTransactionPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[ConfirmedTransactionPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(ConfirmedTransactionInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(ConfirmedTransactionRouterInput));
    self.mockView = OCMProtocolMock(@protocol(ConfirmedTransactionViewInput));

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

#pragma mark - ConfirmedTransactionModuleInput tests

#pragma mark - ConfirmedTransactionViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - ConfirmedTransactionInteractorOutput tests

@end
