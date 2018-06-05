//
//  SettingsRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "SettingsRouter.h"

@interface SettingsRouterTests : XCTestCase

@property (nonatomic, strong) SettingsRouter *router;

@end

@implementation SettingsRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[SettingsRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
