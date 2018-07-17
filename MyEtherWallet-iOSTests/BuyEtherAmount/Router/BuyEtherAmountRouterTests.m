//
//  BuyEtherAmountRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BuyEtherAmountRouter.h"

@interface BuyEtherAmountRouterTests : XCTestCase

@property (nonatomic, strong) BuyEtherAmountRouter *router;

@end

@implementation BuyEtherAmountRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[BuyEtherAmountRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
