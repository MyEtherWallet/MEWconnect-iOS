//
//  BackupStartPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupStartPresenter.h"

#import "BackupStartViewInput.h"
#import "BackupStartInteractorInput.h"
#import "BackupStartRouterInput.h"

@interface BackupStartPresenterTests : XCTestCase

@property (nonatomic, strong) BackupStartPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation BackupStartPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[BackupStartPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(BackupStartInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(BackupStartRouterInput));
    self.mockView = OCMProtocolMock(@protocol(BackupStartViewInput));

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

#pragma mark - BackupStartModuleInput tests

#pragma mark - BackupStartViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialState]);
}

#pragma mark - BackupStartInteractorOutput tests

@end
