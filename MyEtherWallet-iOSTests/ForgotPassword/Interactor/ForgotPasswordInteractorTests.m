//
//  ForgotPasswordInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ForgotPasswordInteractor.h"

#import "ForgotPasswordInteractorOutput.h"

@interface ForgotPasswordInteractorTests : XCTestCase

@property (nonatomic, strong) ForgotPasswordInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ForgotPasswordInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[ForgotPasswordInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ForgotPasswordInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - ForgotPasswordInteractorInput tests

@end
