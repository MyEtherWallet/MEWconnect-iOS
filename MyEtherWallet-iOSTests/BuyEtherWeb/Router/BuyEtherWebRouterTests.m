//
//  BuyEtherWebRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 05/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherWebRouter.h"

@interface BuyEtherWebRouterTests : XCTestCase

@property (nonatomic, strong) BuyEtherWebRouter *router;

@end

@implementation BuyEtherWebRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[BuyEtherWebRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
