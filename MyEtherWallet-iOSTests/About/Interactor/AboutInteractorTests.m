//
//  AboutInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "AboutInteractor.h"

#import "AboutInteractorOutput.h"

@interface AboutInteractorTests : XCTestCase

@property (nonatomic, strong) AboutInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation AboutInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[AboutInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(AboutInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - AboutInteractorInput tests

@end
