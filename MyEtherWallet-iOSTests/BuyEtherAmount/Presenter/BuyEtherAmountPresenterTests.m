//
//  BuyEtherAmountPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherAmountPresenter.h"

#import "BuyEtherAmountViewInput.h"
#import "BuyEtherAmountInteractorInput.h"
#import "BuyEtherAmountRouterInput.h"

@interface BuyEtherAmountPresenterTests : XCTestCase

@property (nonatomic, strong) BuyEtherAmountPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation BuyEtherAmountPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[BuyEtherAmountPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(BuyEtherAmountInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(BuyEtherAmountRouterInput));
    self.mockView = OCMProtocolMock(@protocol(BuyEtherAmountViewInput));

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

#pragma mark - BuyEtherAmountModuleInput tests

#pragma mark - BuyEtherAmountViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - BuyEtherAmountInteractorOutput tests

@end
