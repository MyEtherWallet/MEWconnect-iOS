//
//  RestoreSeedRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/11/2018.
//  Copyright © 2018 MyEtherWallet, Inc.. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreSeedRouter.h"

@interface RestoreSeedRouterTests : XCTestCase

@property (nonatomic, strong) RestoreSeedRouter *router;

@end

@implementation RestoreSeedRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[RestoreSeedRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
