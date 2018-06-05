//
//  ForgotPasswordPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ForgotPasswordPresenter.h"

#import "ForgotPasswordViewInput.h"
#import "ForgotPasswordInteractorInput.h"
#import "ForgotPasswordRouterInput.h"

@interface ForgotPasswordPresenterTests : XCTestCase

@property (nonatomic, strong) ForgotPasswordPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation ForgotPasswordPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[ForgotPasswordPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(ForgotPasswordInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(ForgotPasswordRouterInput));
    self.mockView = OCMProtocolMock(@protocol(ForgotPasswordViewInput));

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

#pragma mark - ForgotPasswordModuleInput tests

#pragma mark - ForgotPasswordViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - ForgotPasswordInteractorOutput tests

@end
