//
//  SplashPasswordPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "SplashPasswordPresenter.h"

#import "SplashPasswordViewInput.h"
#import "SplashPasswordInteractorInput.h"
#import "SplashPasswordRouterInput.h"

@interface SplashPasswordPresenterTests : XCTestCase

@property (nonatomic, strong) SplashPasswordPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation SplashPasswordPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[SplashPasswordPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(SplashPasswordInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(SplashPasswordRouterInput));
    self.mockView = OCMProtocolMock(@protocol(SplashPasswordViewInput));

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

#pragma mark - SplashPasswordModuleInput tests

#pragma mark - SplashPasswordViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - SplashPasswordInteractorOutput tests

@end
