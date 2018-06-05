//
//  BackupInfoInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupInfoInteractor.h"

#import "BackupInfoInteractorOutput.h"

@interface BackupInfoInteractorTests : XCTestCase

@property (nonatomic, strong) BackupInfoInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BackupInfoInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[BackupInfoInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BackupInfoInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - BackupInfoInteractorInput tests

@end
