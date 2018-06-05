//
//  HomeRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "HomeRouter.h"

@interface HomeRouterTests : XCTestCase

@property (nonatomic, strong) HomeRouter *router;

@end

@implementation HomeRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[HomeRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
