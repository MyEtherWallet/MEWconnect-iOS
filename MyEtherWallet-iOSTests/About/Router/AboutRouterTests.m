//
//  AboutRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "AboutRouter.h"

@interface AboutRouterTests : XCTestCase

@property (nonatomic, strong) AboutRouter *router;

@end

@implementation AboutRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[AboutRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
