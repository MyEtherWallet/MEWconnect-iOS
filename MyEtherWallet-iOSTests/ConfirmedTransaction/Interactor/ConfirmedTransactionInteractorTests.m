//
//  ConfirmedTransactionInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmedTransactionInteractor.h"

#import "ConfirmedTransactionInteractorOutput.h"

@interface ConfirmedTransactionInteractorTests : XCTestCase

@property (nonatomic, strong) ConfirmedTransactionInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ConfirmedTransactionInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[ConfirmedTransactionInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ConfirmedTransactionInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - ConfirmedTransactionInteractorInput tests

@end
