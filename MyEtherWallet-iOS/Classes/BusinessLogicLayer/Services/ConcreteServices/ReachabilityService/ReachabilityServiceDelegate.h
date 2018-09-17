//
//  ReachabilityServiceDelegate.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 31/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@protocol ReachabilityServiceDelegate <NSObject>
- (void) reachabilityStatusDidChanged:(BOOL)isReachable;
@end
