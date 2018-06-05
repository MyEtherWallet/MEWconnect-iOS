//
//  BackupConfirmationRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupConfirmationRouter.h"

@interface BackupConfirmationRouterTests : XCTestCase

@property (nonatomic, strong) BackupConfirmationRouter *router;

@end

@implementation BackupConfirmationRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[BackupConfirmationRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
