//
//  ContextPasswordInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ContextPasswordInteractor.h"

#import "ContextPasswordInteractorOutput.h"

@interface ContextPasswordInteractorTests : XCTestCase

@property (nonatomic, strong) ContextPasswordInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ContextPasswordInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[ContextPasswordInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ContextPasswordInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - ContextPasswordInteractorInput tests

@end
