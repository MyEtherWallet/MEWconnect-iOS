//
//  BackupWordsPresenterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupWordsPresenter.h"

#import "BackupWordsViewInput.h"
#import "BackupWordsInteractorInput.h"
#import "BackupWordsRouterInput.h"

@interface BackupWordsPresenterTests : XCTestCase

@property (nonatomic, strong) BackupWordsPresenter *presenter;

@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockRouter;
@property (nonatomic, strong) id mockView;

@end

@implementation BackupWordsPresenterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.presenter = [[BackupWordsPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(BackupWordsInteractorInput));
    self.mockRouter = OCMProtocolMock(@protocol(BackupWordsRouterInput));
    self.mockView = OCMProtocolMock(@protocol(BackupWordsViewInput));

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

#pragma mark - BackupWordsModuleInput tests

#pragma mark - BackupWordsViewOutput tests

- (void)testThatPresenterHandlesViewReadyEvent {
    // given


    // when
    [self.presenter didTriggerViewReadyEvent];

    // then
    OCMVerify([self.mockView setupInitialStateWithWords:@[]]);
}

#pragma mark - BackupWordsInteractorOutput tests

@end
