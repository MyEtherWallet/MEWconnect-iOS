//
//  BackupDoneInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupDoneInteractor.h"

#import "BackupDoneInteractorOutput.h"

@interface BackupDoneInteractorTests : XCTestCase

@property (nonatomic, strong) BackupDoneInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BackupDoneInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[BackupDoneInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BackupDoneInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - BackupDoneInteractorInput tests

@end
