//
//  SettingsInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "SettingsInteractor.h"

#import "SettingsInteractorOutput.h"

@interface SettingsInteractorTests : XCTestCase

@property (nonatomic, strong) SettingsInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation SettingsInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[SettingsInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(SettingsInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - SettingsInteractorInput tests

@end
