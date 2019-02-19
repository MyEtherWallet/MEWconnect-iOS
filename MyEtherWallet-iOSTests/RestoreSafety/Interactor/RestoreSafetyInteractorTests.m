//
//  RestoreSafetyInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreSafetyInteractor.h"

#import "RestoreSafetyInteractorOutput.h"

@interface RestoreSafetyInteractorTests : XCTestCase

@property (nonatomic, strong) RestoreSafetyInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RestoreSafetyInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[RestoreSafetyInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RestoreSafetyInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - RestoreSafetyInteractorInput tests

@end
