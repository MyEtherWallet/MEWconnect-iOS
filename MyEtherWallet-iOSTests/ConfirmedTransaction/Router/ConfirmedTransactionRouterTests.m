//
//  ConfirmedTransactionRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmedTransactionRouter.h"

@interface ConfirmedTransactionRouterTests : XCTestCase

@property (nonatomic, strong) ConfirmedTransactionRouter *router;

@end

@implementation ConfirmedTransactionRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[ConfirmedTransactionRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
