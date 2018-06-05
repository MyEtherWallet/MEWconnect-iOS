//
//  DeclinedTransactionRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "DeclinedTransactionRouter.h"

@interface DeclinedTransactionRouterTests : XCTestCase

@property (nonatomic, strong) DeclinedTransactionRouter *router;

@end

@implementation DeclinedTransactionRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[DeclinedTransactionRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
