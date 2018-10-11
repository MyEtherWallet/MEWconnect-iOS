//
//  ShareRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ShareRouter.h"

@interface ShareRouterTests : XCTestCase

@property (nonatomic, strong) ShareRouter *router;

@end

@implementation ShareRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[ShareRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
