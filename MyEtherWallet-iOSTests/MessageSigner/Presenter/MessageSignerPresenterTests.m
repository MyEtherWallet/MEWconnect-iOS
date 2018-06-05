//
//  MessageSignerPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "MessageSignerPresenter.h"

#import "MessageSignerViewInput.h"
#import "MessageSignerInteractorInput.h"
#import "MessageSignerRouterInput.h"

@interface MessageSignerPresenterTests : XCTestCase

@property (nonatomic, strong) MessageSignerPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation MessageSignerPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[MessageSignerPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(MessageSignerInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(MessageSignerRouterInput));
    self.mockView = OCMProtocolMock(@protocol(MessageSignerViewInput));

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

#pragma mark - MessageSignerModuleInput tests

#pragma mark - MessageSignerViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - MessageSignerInteractorOutput tests

@end
