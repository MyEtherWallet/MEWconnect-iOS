//
//  BackupConfirmationPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupConfirmationPresenter.h"

#import "BackupConfirmationViewInput.h"
#import "BackupConfirmationInteractorInput.h"
#import "BackupConfirmationRouterInput.h"

@interface BackupConfirmationPresenterTests : XCTestCase

@property (nonatomic, strong) BackupConfirmationPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation BackupConfirmationPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[BackupConfirmationPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(BackupConfirmationInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(BackupConfirmationRouterInput));
    self.mockView = OCMProtocolMock(@protocol(BackupConfirmationViewInput));

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

#pragma mark - BackupConfirmationModuleInput tests

#pragma mark - BackupConfirmationViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialStateWithQuiz:nil]);
}

#pragma mark - BackupConfirmationInteractorOutput tests

@end
