//
//  InfoPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "InfoPresenter.h"

#import "InfoViewInput.h"
#import "InfoInteractorInput.h"
#import "InfoRouterInput.h"

@interface InfoPresenterTests : XCTestCase

@property (nonatomic, strong) InfoPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation InfoPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[InfoPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(InfoInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(InfoRouterInput));
    self.mockView = OCMProtocolMock(@protocol(InfoViewInput));

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

#pragma mark - InfoModuleInput tests

#pragma mark - InfoViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - InfoInteractorOutput tests

@end
