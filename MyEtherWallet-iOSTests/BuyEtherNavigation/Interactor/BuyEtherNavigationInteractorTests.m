//
//  BuyEtherNavigationInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherNavigationInteractor.h"

#import "BuyEtherNavigationInteractorOutput.h"

@interface BuyEtherNavigationInteractorTests : XCTestCase

@property (nonatomic, strong) BuyEtherNavigationInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation BuyEtherNavigationInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[BuyEtherNavigationInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(BuyEtherNavigationInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - BuyEtherNavigationInteractorInput tests

@end
