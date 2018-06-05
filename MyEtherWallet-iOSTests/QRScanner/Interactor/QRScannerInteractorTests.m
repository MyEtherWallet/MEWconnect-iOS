//
//  QRScannerInteractorTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "QRScannerInteractor.h"

#import "QRScannerInteractorOutput.h"

@interface QRScannerInteractorTests : XCTestCase

@property (nonatomic, strong) QRScannerInteractor *interactor;

@property (nonatomic, strong) id mockOutput;

@end

@implementation QRScannerInteractorTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.interactor = [[QRScannerInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(QRScannerInteractorOutput));

    self.interactor.output = self.mockOutput;
}

- (void)tearDown {
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

#pragma mark - QRScannerInteractorInput tests

@end
