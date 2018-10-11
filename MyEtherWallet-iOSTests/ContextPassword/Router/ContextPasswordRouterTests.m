//
//  ContextPasswordRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ContextPasswordRouter.h"

@interface ContextPasswordRouterTests : XCTestCase

@property (nonatomic, strong) ContextPasswordRouter *router;

@end

@implementation ContextPasswordRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[ContextPasswordRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
