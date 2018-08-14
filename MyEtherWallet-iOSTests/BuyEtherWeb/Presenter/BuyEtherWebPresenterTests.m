//
//  BuyEtherWebPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherWebPresenter.h"

#import "BuyEtherWebViewInput.h"
#import "BuyEtherWebInteractorInput.h"
#import "BuyEtherWebRouterInput.h"

@interface BuyEtherWebPresenterTests : XCTestCase

@property (nonatomic, strong) BuyEtherWebPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation BuyEtherWebPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[BuyEtherWebPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(BuyEtherWebInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(BuyEtherWebRouterInput));
    self.mockView = OCMProtocolMock(@protocol(BuyEtherWebViewInput));

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

#pragma mark - BuyEtherWebModuleInput tests

#pragma mark - BuyEtherWebViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - BuyEtherWebInteractorOutput tests

@end
