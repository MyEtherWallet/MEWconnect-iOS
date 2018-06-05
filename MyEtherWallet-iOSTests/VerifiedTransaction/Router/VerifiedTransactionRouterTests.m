//
//  VerifiedTransactionRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "VerifiedTransactionRouter.h"

@interface VerifiedTransactionRouterTests : XCTestCase

@property (nonatomic, strong) VerifiedTransactionRouter *router;

@end

@implementation VerifiedTransactionRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[VerifiedTransactionRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
