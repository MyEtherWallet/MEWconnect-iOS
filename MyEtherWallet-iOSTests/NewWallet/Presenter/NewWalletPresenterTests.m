//
//  NewWalletPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "NewWalletPresenter.h"

#import "NewWalletViewInput.h"
#import "NewWalletInteractorInput.h"
#import "NewWalletRouterInput.h"

@interface NewWalletPresenterTests : XCTestCase

@property (nonatomic, strong) NewWalletPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation NewWalletPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[NewWalletPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(NewWalletInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(NewWalletRouterInput));
    self.mockView = OCMProtocolMock(@protocol(NewWalletViewInput));

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

#pragma mark - NewWalletModuleInput tests

#pragma mark - NewWalletViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - NewWalletInteractorOutput tests

@end
