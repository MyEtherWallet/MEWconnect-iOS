//
//  SettingsPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "SettingsPresenter.h"

#import "SettingsViewInput.h"
#import "SettingsInteractorInput.h"
#import "SettingsRouterInput.h"

@interface SettingsPresenterTests : XCTestCase

@property (nonatomic, strong) SettingsPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation SettingsPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[SettingsPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(SettingsInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(SettingsRouterInput));
    self.mockView = OCMProtocolMock(@protocol(SettingsViewInput));

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

#pragma mark - SettingsModuleInput tests

#pragma mark - SettingsViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - SettingsInteractorOutput tests

@end
