//
//  BackupConfirmationInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupConfirmationInteractor.h"

#import "BackupConfirmationInteractorOutput.h"

@interface BackupConfirmationInteractorTests : XCTestCase

@property (nonatomic, strong) BackupConfirmationInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BackupConfirmationInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[BackupConfirmationInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BackupConfirmationInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - BackupConfirmationInteractorInput tests

@end
