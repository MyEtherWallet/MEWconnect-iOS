//
//  SimplexHeadersBuilder.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SimplexHeadersBuilder.h"

@implementation SimplexHeadersBuilder

- (NSDictionary *)build {
  NSMutableDictionary *headers = [[super build] mutableCopy];
  [headers addEntriesFromDictionary:self.additionalHeaders];
  return headers;
}

@end
