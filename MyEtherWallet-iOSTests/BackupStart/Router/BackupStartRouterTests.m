//
//  BackupStartRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupStartRouter.h"

@interface BackupStartRouterTests : XCTestCase

@property (nonatomic, strong) BackupStartRouter *router;

@end

@implementation BackupStartRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[BackupStartRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
