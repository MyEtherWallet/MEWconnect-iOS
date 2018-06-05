//
//  SplashPasswordRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "SplashPasswordRouter.h"

@interface SplashPasswordRouterTests : XCTestCase

@property (nonatomic, strong) SplashPasswordRouter *router;

@end

@implementation SplashPasswordRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[SplashPasswordRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
