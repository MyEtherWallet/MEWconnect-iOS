//
//  ForgotPasswordRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ForgotPasswordRouter.h"

@interface ForgotPasswordRouterTests : XCTestCase

@property (nonatomic, strong) ForgotPasswordRouter *router;

@end

@implementation ForgotPasswordRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[ForgotPasswordRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
