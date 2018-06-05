//
//  NewWalletRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "NewWalletRouter.h"

@interface NewWalletRouterTests : XCTestCase

@property (nonatomic, strong) NewWalletRouter *router;

@end

@implementation NewWalletRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[NewWalletRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
