//
//  VerifiedTransactionPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "VerifiedTransactionPresenter.h"

#import "VerifiedTransactionViewInput.h"
#import "VerifiedTransactionInteractorInput.h"
#import "VerifiedTransactionRouterInput.h"

@interface VerifiedTransactionPresenterTests : XCTestCase

@property (nonatomic, strong) VerifiedTransactionPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation VerifiedTransactionPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[VerifiedTransactionPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(VerifiedTransactionInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(VerifiedTransactionRouterInput));
    self.mockView = OCMProtocolMock(@protocol(VerifiedTransactionViewInput));

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

#pragma mark - VerifiedTransactionModuleInput tests

#pragma mark - VerifiedTransactionViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - VerifiedTransactionInteractorOutput tests

@end
