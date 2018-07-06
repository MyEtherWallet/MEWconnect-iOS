//
//  BuyEtherAmountInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherAmountInteractor.h"

#import "BuyEtherAmountInteractorOutput.h"

@interface BuyEtherAmountInteractorTests : XCTestCase

@property (nonatomic, strong) BuyEtherAmountInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BuyEtherAmountInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[BuyEtherAmountInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BuyEtherAmountInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - BuyEtherAmountInteractorInput tests

@end
