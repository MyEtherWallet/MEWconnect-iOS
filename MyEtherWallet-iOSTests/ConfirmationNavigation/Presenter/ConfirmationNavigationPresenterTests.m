//
//  ConfirmationNavigationPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmationNavigationPresenter.h"

#import "ConfirmationNavigationViewInput.h"
#import "ConfirmationNavigationInteractorInput.h"
#import "ConfirmationNavigationRouterInput.h"

@interface ConfirmationNavigationPresenterTests : XCTestCase

@property (nonatomic, strong) ConfirmationNavigationPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation ConfirmationNavigationPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[ConfirmationNavigationPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(ConfirmationNavigationInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(ConfirmationNavigationRouterInput));
    self.mockView = OCMProtocolMock(@protocol(ConfirmationNavigationViewInput));

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

#pragma mark - ConfirmationNavigationModuleInput tests

#pragma mark - ConfirmationNavigationViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - ConfirmationNavigationInteractorOutput tests

@end
