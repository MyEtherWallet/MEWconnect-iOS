//
//  SplashPasswordInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "SplashPasswordInteractor.h"

#import "SplashPasswordInteractorOutput.h"

@interface SplashPasswordInteractorTests : XCTestCase

@property (nonatomic, strong) SplashPasswordInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation SplashPasswordInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[SplashPasswordInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(SplashPasswordInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - SplashPasswordInteractorInput tests

@end
