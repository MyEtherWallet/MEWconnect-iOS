//
//  BackupInfoPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupInfoPresenter.h"

#import "BackupInfoViewInput.h"
#import "BackupInfoInteractorInput.h"
#import "BackupInfoRouterInput.h"

@interface BackupInfoPresenterTests : XCTestCase

@property (nonatomic, strong) BackupInfoPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation BackupInfoPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[BackupInfoPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(BackupInfoInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(BackupInfoRouterInput));
    self.mockView = OCMProtocolMock(@protocol(BackupInfoViewInput));

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

#pragma mark - BackupInfoModuleInput tests

#pragma mark - BackupInfoViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - BackupInfoInteractorOutput tests

@end
