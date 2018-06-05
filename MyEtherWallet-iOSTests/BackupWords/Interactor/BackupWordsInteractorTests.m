//
//  BackupWordsInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupWordsInteractor.h"

#import "BackupWordsInteractorOutput.h"

@interface BackupWordsInteractorTests : XCTestCase

@property (nonatomic, strong) BackupWordsInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BackupWordsInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[BackupWordsInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BackupWordsInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - BackupWordsInteractorInput tests

@end
