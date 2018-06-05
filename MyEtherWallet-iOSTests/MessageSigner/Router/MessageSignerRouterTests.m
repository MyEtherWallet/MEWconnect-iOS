//
//  MessageSignerRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "MessageSignerRouter.h"

@interface MessageSignerRouterTests : XCTestCase

@property (nonatomic, strong) MessageSignerRouter *router;

@end

@implementation MessageSignerRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[MessageSignerRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
