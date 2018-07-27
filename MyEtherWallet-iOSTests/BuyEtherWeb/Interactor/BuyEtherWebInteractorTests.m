//
//  BuyEtherWebInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherWebInteractor.h"

#import "BuyEtherWebInteractorOutput.h"

@interface BuyEtherWebInteractorTests : XCTestCase

@property (nonatomic, strong) BuyEtherWebInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BuyEtherWebInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[BuyEtherWebInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BuyEtherWebInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - BuyEtherWebInteractorInput tests

@end
