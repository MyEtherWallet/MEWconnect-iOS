//
//  MessageSignerInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "MessageSignerInteractor.h"

#import "MessageSignerInteractorOutput.h"

@interface MessageSignerInteractorTests : XCTestCase

@property (nonatomic, strong) MessageSignerInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation MessageSignerInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[MessageSignerInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(MessageSignerInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - MessageSignerInteractorInput tests

@end
