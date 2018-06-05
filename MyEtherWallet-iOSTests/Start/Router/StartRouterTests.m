//
//  StartRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "StartRouter.h"

@interface StartRouterTests : XCTestCase

@property (nonatomic, strong) StartRouter *router;

@end

@implementation StartRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[StartRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
