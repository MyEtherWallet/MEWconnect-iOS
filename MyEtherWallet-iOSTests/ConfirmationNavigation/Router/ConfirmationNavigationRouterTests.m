//
//  ConfirmationNavigationRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "ConfirmationNavigationRouter.h"

@interface ConfirmationNavigationRouterTests : XCTestCase

@property (nonatomic, strong) ConfirmationNavigationRouter *router;

@end

@implementation ConfirmationNavigationRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[ConfirmationNavigationRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
