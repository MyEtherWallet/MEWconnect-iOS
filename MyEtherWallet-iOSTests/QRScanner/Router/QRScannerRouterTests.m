//
//  QRScannerRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "QRScannerRouter.h"

@interface QRScannerRouterTests : XCTestCase

@property (nonatomic, strong) QRScannerRouter *router;

@end

@implementation QRScannerRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[QRScannerRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
