//
//  PasswordPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "PasswordPresenter.h"

#import "PasswordViewInput.h"
#import "PasswordInteractorInput.h"
#import "PasswordRouterInput.h"

@interface PasswordPresenterTests : XCTestCase

@property (nonatomic, strong) PasswordPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation PasswordPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[PasswordPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(PasswordInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(PasswordRouterInput));
    self.mockView = OCMProtocolMock(@protocol(PasswordViewInput));

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

#pragma mark - PasswordModuleInput tests

#pragma mark - PasswordViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialStateWithBackButton:NO]);
}

#pragma mark - PasswordInteractorOutput tests

@end
