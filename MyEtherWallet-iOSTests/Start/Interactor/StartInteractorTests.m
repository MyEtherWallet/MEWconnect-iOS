//
//  StartInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "StartInteractor.h"

#import "StartInteractorOutput.h"

@interface StartInteractorTests : XCTestCase

@property (nonatomic, strong) StartInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation StartInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[StartInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(StartInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - StartInteractorInput tests

@end
