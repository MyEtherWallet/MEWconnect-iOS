//
//  InfoRouterTests.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import XCTest;
@import OCMock;

#import "InfoRouter.h"

@interface InfoRouterTests : XCTestCase

@property (nonatomic, strong) InfoRouter *router;

@end

@implementation InfoRouterTests

#pragma mark - Config the environment

- (void)setUp {
    [super setUp];

    self.router = [[InfoRouter alloc] init];
}

- (void)tearDown {
    self.router = nil;

    [super tearDown];
}

@end
