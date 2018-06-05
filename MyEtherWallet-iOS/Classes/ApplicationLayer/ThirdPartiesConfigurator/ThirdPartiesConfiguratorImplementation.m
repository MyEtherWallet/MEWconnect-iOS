//
//  ThirdPartiesConfiguratorImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ThirdPartiesConfiguratorImplementation.h"
@import CocoaLumberjack;

@implementation ThirdPartiesConfiguratorImplementation

- (void)configurate {
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  [DDLog addLogger:[DDASLLogger sharedInstance]];
}

@end
