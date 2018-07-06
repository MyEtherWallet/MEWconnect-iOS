//
//  InfoInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "InfoInteractor.h"

#import "InfoInteractorOutput.h"

@interface InfoInteractorTests : XCTestCase

@property (nonatomic, strong) InfoInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation InfoInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[InfoInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(InfoInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - InfoInteractorInput tests

@end
