//
//  ContextPasswordPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ContextPasswordPresenter.h"

#import "ContextPasswordViewInput.h"
#import "ContextPasswordInteractorInput.h"
#import "ContextPasswordRouterInput.h"

@interface ContextPasswordPresenterTests : XCTestCase

@property (nonatomic, strong) ContextPasswordPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation ContextPasswordPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[ContextPasswordPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(ContextPasswordInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(ContextPasswordRouterInput));
    self.mockView = OCMProtocolMock(@protocol(ContextPasswordViewInput));

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

#pragma mark - ContextPasswordModuleInput tests

#pragma mark - ContextPasswordViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - ContextPasswordInteractorOutput tests

@end
