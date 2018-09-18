//
//  CrashCatcherConfiguratorImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 17/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "CrashCatcherConfigurator.h"

@protocol RateService;

NS_ASSUME_NONNULL_BEGIN

@interface CrashCatcherConfiguratorImplementation : NSObject <CrashCatcherConfigurator>
@property (nonatomic, strong) id <RateService> rateService;
@end

NS_ASSUME_NONNULL_END
