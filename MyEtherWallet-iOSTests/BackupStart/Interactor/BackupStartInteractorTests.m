//
//  BackupStartInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupStartInteractor.h"

#import "BackupStartInteractorOutput.h"

@interface BackupStartInteractorTests : XCTestCase

@property (nonatomic, strong) BackupStartInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BackupStartInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[BackupStartInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BackupStartInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - BackupStartInteractorInput tests

@end
