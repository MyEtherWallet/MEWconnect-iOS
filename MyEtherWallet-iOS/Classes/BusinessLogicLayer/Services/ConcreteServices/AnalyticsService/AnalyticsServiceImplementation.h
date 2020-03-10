//
//  AnalyticsServiceImplementation.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/10/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

#import "AnalyticsService.h"

@class AnalyticsOperationFactory;
@protocol OperationScheduler;

NS_ASSUME_NONNULL_BEGIN

@interface AnalyticsServiceImplementation : NSObject <AnalyticsService>
@property (nonatomic, strong) AnalyticsOperationFactory *analyticsOperationFactory;
@property (nonatomic, strong) id <OperationScheduler> operationScheduler;
@end

NS_ASSUME_NONNULL_END
