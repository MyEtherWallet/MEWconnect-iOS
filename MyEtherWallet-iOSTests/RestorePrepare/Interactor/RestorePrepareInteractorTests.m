//
//  RestorePrepareInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestorePrepareInteractor.h"

#import "RestorePrepareInteractorOutput.h"

@interface RestorePrepareInteractorTests : XCTestCase

@property (nonatomic, strong) RestorePrepareInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation RestorePrepareInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[RestorePrepareInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(RestorePrepareInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - RestorePrepareInteractorInput tests

@end
