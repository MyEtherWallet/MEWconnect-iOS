//
//  SharePresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "SharePresenter.h"

#import "ShareViewInput.h"
#import "ShareInteractorInput.h"
#import "ShareRouterInput.h"

@interface SharePresenterTests : XCTestCase

@property (nonatomic, strong) SharePresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation SharePresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[SharePresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(ShareInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(ShareRouterInput));
    self.mockView = OCMProtocolMock(@protocol(ShareViewInput));

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

#pragma mark - ShareModuleInput tests

#pragma mark - ShareViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - ShareInteractorOutput tests

@end
