//
//  PasswordRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "PasswordRouter.h"

@interface PasswordRouterTests : XCTestCase

@property (nonatomic, strong) PasswordRouter *router;

@end

@implementation PasswordRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[PasswordRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
