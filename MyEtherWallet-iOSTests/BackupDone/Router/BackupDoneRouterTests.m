//
//  BackupDoneRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupDoneRouter.h"

@interface BackupDoneRouterTests : XCTestCase

@property (nonatomic, strong) BackupDoneRouter *router;

@end

@implementation BackupDoneRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[BackupDoneRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
