//
//  BuyEtherNavigationRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherNavigationRouter.h"

@interface BuyEtherNavigationRouterTests : XCTestCase

@property (nonatomic, strong) BuyEtherNavigationRouter *router;

@end

@implementation BuyEtherNavigationRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[BuyEtherNavigationRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
