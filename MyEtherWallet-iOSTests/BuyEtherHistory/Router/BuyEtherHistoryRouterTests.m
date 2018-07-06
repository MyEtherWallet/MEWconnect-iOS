//
//  BuyEtherHistoryRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherHistoryRouter.h"

@interface BuyEtherHistoryRouterTests : XCTestCase

@property (nonatomic, strong) BuyEtherHistoryRouter *router;

@end

@implementation BuyEtherHistoryRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[BuyEtherHistoryRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
