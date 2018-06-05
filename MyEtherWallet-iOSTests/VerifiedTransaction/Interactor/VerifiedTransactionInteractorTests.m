//
//  VerifiedTransactionInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "VerifiedTransactionInteractor.h"

#import "VerifiedTransactionInteractorOutput.h"

@interface VerifiedTransactionInteractorTests : XCTestCase

@property (nonatomic, strong) VerifiedTransactionInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation VerifiedTransactionInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[VerifiedTransactionInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(VerifiedTransactionInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - VerifiedTransactionInteractorInput tests

@end
