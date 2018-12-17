//
//  ShareInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ShareInteractor.h"

#import "ShareInteractorOutput.h"

@interface ShareInteractorTests : XCTestCase

@property (nonatomic, strong) ShareInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation ShareInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[ShareInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(ShareInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - ShareInteractorInput tests

@end
