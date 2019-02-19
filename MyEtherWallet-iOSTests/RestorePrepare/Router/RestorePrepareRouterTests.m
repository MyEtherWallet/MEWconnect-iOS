//
//  RestorePrepareRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestorePrepareRouter.h"

@interface RestorePrepareRouterTests : XCTestCase

@property (nonatomic, strong) RestorePrepareRouter *router;

@end

@implementation RestorePrepareRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[RestorePrepareRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
