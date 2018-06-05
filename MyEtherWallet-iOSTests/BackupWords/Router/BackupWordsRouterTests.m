//
//  BackupWordsRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "BackupWordsRouter.h"

@interface BackupWordsRouterTests : XCTestCase

@property (nonatomic, strong) BackupWordsRouter *router;

@end

@implementation BackupWordsRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[BackupWordsRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
