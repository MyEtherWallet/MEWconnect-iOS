//
//  BackupDonePresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupDonePresenter.h"

#import "BackupDoneViewInput.h"
#import "BackupDoneInteractorInput.h"
#import "BackupDoneRouterInput.h"

@interface BackupDonePresenterTests : XCTestCase

@property (nonatomic, strong) BackupDonePresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation BackupDonePresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[BackupDonePresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(BackupDoneInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(BackupDoneRouterInput));
    self.mockView = OCMProtocolMock(@protocol(BackupDoneViewInput));

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

#pragma mark - BackupDoneModuleInput tests

#pragma mark - BackupDoneViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - BackupDoneInteractorOutput tests

@end
