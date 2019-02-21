//
//  RestorePreparePresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestorePreparePresenter.h"

#import "RestorePrepareViewInput.h"
#import "RestorePrepareInteractorInput.h"
#import "RestorePrepareRouterInput.h"

@interface RestorePreparePresenterTests : XCTestCase

@property (nonatomic, strong) RestorePreparePresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation RestorePreparePresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[RestorePreparePresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(RestorePrepareInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(RestorePrepareRouterInput));
    self.mockView = OCMProtocolMock(@protocol(RestorePrepareViewInput));

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

#pragma mark - RestorePrepareModuleInput tests

#pragma mark - RestorePrepareViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - RestorePrepareInteractorOutput tests

@end
