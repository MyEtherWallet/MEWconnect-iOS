//
//  RestoreWalletRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "RestoreWalletRouter.h"

@interface RestoreWalletRouterTests : XCTestCase

@property (nonatomic, strong) RestoreWalletRouter *router;

@end

@implementation RestoreWalletRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[RestoreWalletRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
