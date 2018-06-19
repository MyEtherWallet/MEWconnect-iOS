//
//  ThirdPartiesConfiguratorImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ThirdPartiesConfiguratorImplementation.h"

@implementation ThirdPartiesConfiguratorImplementation

- (void)configurate {
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
#if !DEBUG
  [DDLog addLogger:[DDASLLogger sharedInstance]];
#endif
}

@end
