//
//  RestoreOptionsInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreOptionsInteractor.h"

#import "RestoreOptionsInteractorOutput.h"

@interface RestoreOptionsInteractorTests : XCTestCase

@property (nonatomic, strong) RestoreOptionsInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RestoreOptionsInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[RestoreOptionsInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RestoreOptionsInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - RestoreOptionsInteractorInput tests

@end
