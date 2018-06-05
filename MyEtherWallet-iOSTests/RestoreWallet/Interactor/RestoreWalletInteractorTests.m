//
//  RestoreWalletInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreWalletInteractor.h"

#import "RestoreWalletInteractorOutput.h"

@interface RestoreWalletInteractorTests : XCTestCase

@property (nonatomic, strong) RestoreWalletInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RestoreWalletInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[RestoreWalletInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RestoreWalletInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - RestoreWalletInteractorInput tests

@end
