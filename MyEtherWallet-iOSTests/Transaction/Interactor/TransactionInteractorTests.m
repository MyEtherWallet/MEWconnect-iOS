//
//  TransactionInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "TransactionInteractor.h"

#import "TransactionInteractorOutput.h"

@interface TransactionInteractorTests : XCTestCase

@property (nonatomic, strong) TransactionInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation TransactionInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[TransactionInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(TransactionInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - TransactionInteractorInput tests

@end
