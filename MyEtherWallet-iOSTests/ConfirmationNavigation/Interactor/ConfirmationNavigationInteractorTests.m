//
//  ConfirmationNavigationInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmationNavigationInteractor.h"

#import "ConfirmationNavigationInteractorOutput.h"

@interface ConfirmationNavigationInteractorTests : XCTestCase

@property (nonatomic, strong) ConfirmationNavigationInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ConfirmationNavigationInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[ConfirmationNavigationInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ConfirmationNavigationInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - ConfirmationNavigationInteractorInput tests

@end
