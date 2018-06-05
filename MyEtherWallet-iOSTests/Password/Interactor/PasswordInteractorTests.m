//
//  PasswordInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "PasswordInteractor.h"

#import "PasswordInteractorOutput.h"

@interface PasswordInteractorTests : XCTestCase

@property (nonatomic, strong) PasswordInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation PasswordInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[PasswordInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(PasswordInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - PasswordInteractorInput tests

@end
