//
//  ConfirmPasswordInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmPasswordInteractor.h"

#import "ConfirmPasswordInteractorOutput.h"

@interface ConfirmPasswordInteractorTests : XCTestCase

@property (nonatomic, strong) ConfirmPasswordInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ConfirmPasswordInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[ConfirmPasswordInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ConfirmPasswordInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - ConfirmPasswordInteractorInput tests

@end
