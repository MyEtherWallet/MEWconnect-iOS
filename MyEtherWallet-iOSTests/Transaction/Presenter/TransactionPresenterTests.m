//
//  TransactionPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "TransactionPresenter.h"

#import "TransactionViewInput.h"
#import "TransactionInteractorInput.h"
#import "TransactionRouterInput.h"

@interface TransactionPresenterTests : XCTestCase

@property (nonatomic, strong) TransactionPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation TransactionPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[TransactionPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(TransactionInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(TransactionRouterInput));
    self.mockView = OCMProtocolMock(@protocol(TransactionViewInput));

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

#pragma mark - TransactionModuleInput tests

#pragma mark - TransactionViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - TransactionInteractorOutput tests

@end
