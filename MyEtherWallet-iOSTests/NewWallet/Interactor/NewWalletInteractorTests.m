//
//  NewWalletInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "NewWalletInteractor.h"

#import "NewWalletInteractorOutput.h"

@interface NewWalletInteractorTests : XCTestCase

@property (nonatomic, strong) NewWalletInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation NewWalletInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[NewWalletInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(NewWalletInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - NewWalletInteractorInput tests

@end
