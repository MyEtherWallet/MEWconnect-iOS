//
//  ReachabilityServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 31/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ReachabilityService.h"

@class AFNetworkReachabilityManager;
@protocol ReachabilityServiceDelegate;

@interface ReachabilityServiceImplementation : NSObject <ReachabilityService>
@property (nonatomic, weak) id <ReachabilityServiceDelegate> delegate;
@property (nonatomic, strong, readonly) AFNetworkReachabilityManager *reachabilityManager;
- (instancetype) initWithNetworkReachabilityManager:(AFNetworkReachabilityManager *)manager;
@end
