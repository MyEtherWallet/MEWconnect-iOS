//
//  RestoreSeedPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreSeedPresenter.h"

#import "RestoreSeedViewInput.h"
#import "RestoreSeedInteractorInput.h"
#import "RestoreSeedRouterInput.h"

@interface RestoreSeedPresenterTests : XCTestCase

@property (nonatomic, strong) RestoreSeedPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation RestoreSeedPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[RestoreSeedPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(RestoreSeedInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(RestoreSeedRouterInput));
    self.mockView = OCMProtocolMock(@protocol(RestoreSeedViewInput));

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

#pragma mark - RestoreSeedModuleInput tests

#pragma mark - RestoreSeedViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - RestoreSeedInteractorOutput tests

@end
