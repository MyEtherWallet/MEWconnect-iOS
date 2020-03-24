//
//  AnalyticsQueryTransformer.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/10/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

#import "AnalyticsQueryTransformer.h"

#import "AnalyticsQuery.h"

static NSString *const kAnalyticsServiceISOParameter = @"iso";

@implementation AnalyticsQueryTransformer

- (NSDictionary *)deriveUrlParametersFromQuery:(AnalyticsQuery *)query {
  return @{kAnalyticsServiceISOParameter: query.iso};
}

@end
