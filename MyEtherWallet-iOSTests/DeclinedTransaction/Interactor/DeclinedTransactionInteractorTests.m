//
//  DeclinedTransactionInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "DeclinedTransactionInteractor.h"

#import "DeclinedTransactionInteractorOutput.h"

@interface DeclinedTransactionInteractorTests : XCTestCase

@property (nonatomic, strong) DeclinedTransactionInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation DeclinedTransactionInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[DeclinedTransactionInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(DeclinedTransactionInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - DeclinedTransactionInteractorInput tests

@end
