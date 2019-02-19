//
//  RestoreOptionsRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreOptionsRouter.h"

@interface RestoreOptionsRouterTests : XCTestCase

@property (nonatomic, strong) RestoreOptionsRouter *router;

@end

@implementation RestoreOptionsRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[RestoreOptionsRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
