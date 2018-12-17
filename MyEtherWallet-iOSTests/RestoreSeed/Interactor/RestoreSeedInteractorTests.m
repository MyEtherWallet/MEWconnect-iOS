//
//  RestoreSeedInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreSeedInteractor.h"

#import "RestoreSeedInteractorOutput.h"

@interface RestoreSeedInteractorTests : XCTestCase

@property (nonatomic, strong) RestoreSeedInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RestoreSeedInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[RestoreSeedInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RestoreSeedInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - RestoreSeedInteractorInput tests

@end
