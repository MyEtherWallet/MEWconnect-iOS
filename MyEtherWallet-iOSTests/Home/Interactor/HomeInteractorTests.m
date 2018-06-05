//
//  HomeInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "HomeInteractor.h"

#import "HomeInteractorOutput.h"

@interface HomeInteractorTests : XCTestCase

@property (nonatomic, strong) HomeInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation HomeInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[HomeInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(HomeInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - HomeInteractorInput tests

@end
