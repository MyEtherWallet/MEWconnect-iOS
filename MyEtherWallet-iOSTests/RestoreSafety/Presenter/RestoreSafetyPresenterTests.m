//
//  RestoreSafetyPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreSafetyPresenter.h"

#import "RestoreSafetyViewInput.h"
#import "RestoreSafetyInteractorInput.h"
#import "RestoreSafetyRouterInput.h"

@interface RestoreSafetyPresenterTests : XCTestCase

@property (nonatomic, strong) RestoreSafetyPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation RestoreSafetyPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[RestoreSafetyPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(RestoreSafetyInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(RestoreSafetyRouterInput));
    self.mockView = OCMProtocolMock(@protocol(RestoreSafetyViewInput));

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

#pragma mark - RestoreSafetyModuleInput tests

#pragma mark - RestoreSafetyViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - RestoreSafetyInteractorOutput tests

@end
