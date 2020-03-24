//
//  AnalyticsBodyTransformer.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/10/20.
//  Copyright © 2020 MyEtherWallet, Inc. All rights reserved.
//

#import "AnalyticsBodyTransformer.h"
#import "AnalyticsBody.h"

static NSString *const kAnalyticsBodyEventKey = @"events";

@implementation AnalyticsBodyTransformer

- (NSData *)deriveDataFromBody:(AnalyticsBody *)body {
  return [NSJSONSerialization dataWithJSONObject:@{kAnalyticsBodyEventKey: body.events} options:0 error:nil];
}

@end
