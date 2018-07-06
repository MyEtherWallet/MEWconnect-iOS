//
//  BuyEtherHistoryInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherHistoryInteractor.h"

#import "BuyEtherHistoryInteractorOutput.h"

@interface BuyEtherHistoryInteractorTests : XCTestCase

@property (nonatomic, strong) BuyEtherHistoryInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BuyEtherHistoryInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[BuyEtherHistoryInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BuyEtherHistoryInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - BuyEtherHistoryInteractorInput tests

@end
