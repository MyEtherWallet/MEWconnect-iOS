//
//  RestoreSafetyRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/02/2019.
//  Copyright © 2019 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreSafetyRouter.h"

@interface RestoreSafetyRouterTests : XCTestCase

@property (nonatomic, strong) RestoreSafetyRouter *router;

@end

@implementation RestoreSafetyRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[RestoreSafetyRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
