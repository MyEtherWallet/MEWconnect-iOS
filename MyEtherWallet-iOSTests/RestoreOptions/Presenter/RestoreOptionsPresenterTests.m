//
//  RestoreOptionsPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreOptionsPresenter.h"

#import "RestoreOptionsViewInput.h"
#import "RestoreOptionsInteractorInput.h"
#import "RestoreOptionsRouterInput.h"

@interface RestoreOptionsPresenterTests : XCTestCase

@property (nonatomic, strong) RestoreOptionsPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation RestoreOptionsPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[RestoreOptionsPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(RestoreOptionsInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(RestoreOptionsRouterInput));
    self.mockView = OCMProtocolMock(@protocol(RestoreOptionsViewInput));

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

#pragma mark - RestoreOptionsModuleInput tests

#pragma mark - RestoreOptionsViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - RestoreOptionsInteractorOutput tests

@end
