//
//  ConfirmPasswordPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmPasswordPresenter.h"

#import "ConfirmPasswordViewInput.h"
#import "ConfirmPasswordInteractorInput.h"
#import "ConfirmPasswordRouterInput.h"

@interface ConfirmPasswordPresenterTests : XCTestCase

@property (nonatomic, strong) ConfirmPasswordPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation ConfirmPasswordPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[ConfirmPasswordPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(ConfirmPasswordInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(ConfirmPasswordRouterInput));
    self.mockView = OCMProtocolMock(@protocol(ConfirmPasswordViewInput));

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

#pragma mark - ConfirmPasswordModuleInput tests

#pragma mark - ConfirmPasswordViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - ConfirmPasswordInteractorOutput tests

@end
