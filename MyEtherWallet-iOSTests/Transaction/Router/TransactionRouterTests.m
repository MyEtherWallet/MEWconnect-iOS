//
//  TransactionRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "TransactionRouter.h"

@interface TransactionRouterTests : XCTestCase

@property (nonatomic, strong) TransactionRouter *router;

@end

@implementation TransactionRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[TransactionRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
