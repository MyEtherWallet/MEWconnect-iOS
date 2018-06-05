//
//  ConfirmPasswordRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmPasswordRouter.h"

@interface ConfirmPasswordRouterTests : XCTestCase

@property (nonatomic, strong) ConfirmPasswordRouter *router;

@end

@implementation ConfirmPasswordRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[ConfirmPasswordRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
