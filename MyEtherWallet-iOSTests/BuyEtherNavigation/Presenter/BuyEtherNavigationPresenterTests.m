//
//  BuyEtherNavigationPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherNavigationPresenter.h"

#import "BuyEtherNavigationViewInput.h"
#import "BuyEtherNavigationInteractorInput.h"
#import "BuyEtherNavigationRouterInput.h"

@interface BuyEtherNavigationPresenterTests : XCTestCase

@property (nonatomic, strong) BuyEtherNavigationPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation BuyEtherNavigationPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[BuyEtherNavigationPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(BuyEtherNavigationInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(BuyEtherNavigationRouterInput));
    self.mockView = OCMProtocolMock(@protocol(BuyEtherNavigationViewInput));

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

#pragma mark - BuyEtherNavigationModuleInput tests

#pragma mark - BuyEtherNavigationViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - BuyEtherNavigationInteractorOutput tests

@end
