//
//  ThirdPartiesConfiguratorImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import WebRTC;

#import "ThirdPartiesConfiguratorImplementation.h"

@implementation ThirdPartiesConfiguratorImplementation

- (void) configurate {
  /* Logger */
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
#if !DEBUG
  [DDLog addLogger:[DDASLLogger sharedInstance]];
#endif
  /* WebRTC */
  RTCInitializeSSL();
}

- (void) cleanup {
  /* WebRTC */
  RTCCleanupSSL();
}

@end
