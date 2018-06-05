//
//  DeclinedTransactionPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "DeclinedTransactionPresenter.h"

#import "DeclinedTransactionViewInput.h"
#import "DeclinedTransactionInteractorInput.h"
#import "DeclinedTransactionRouterInput.h"

@interface DeclinedTransactionPresenterTests : XCTestCase

@property (nonatomic, strong) DeclinedTransactionPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation DeclinedTransactionPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[DeclinedTransactionPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(DeclinedTransactionInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(DeclinedTransactionRouterInput));
    self.mockView = OCMProtocolMock(@protocol(DeclinedTransactionViewInput));

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

#pragma mark - DeclinedTransactionModuleInput tests

#pragma mark - DeclinedTransactionViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - DeclinedTransactionInteractorOutput tests

@end
