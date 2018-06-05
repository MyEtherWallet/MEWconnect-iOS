//
//  RestoreWalletPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreWalletPresenter.h"

#import "RestoreWalletViewInput.h"
#import "RestoreWalletInteractorInput.h"
#import "RestoreWalletRouterInput.h"

@interface RestoreWalletPresenterTests : XCTestCase

@property (nonatomic, strong) RestoreWalletPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation RestoreWalletPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[RestoreWalletPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(RestoreWalletInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(RestoreWalletRouterInput));
    self.mockView = OCMProtocolMock(@protocol(RestoreWalletViewInput));

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

#pragma mark - RestoreWalletModuleInput tests

#pragma mark - RestoreWalletViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - RestoreWalletInteractorOutput tests

@end
