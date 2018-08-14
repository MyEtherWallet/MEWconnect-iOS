//
//  ManyResponseObjectFormatter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ManyResponseObjectFormatter.h"

static NSString *const kManyResultsKey = @"result";

@implementation ManyResponseObjectFormatter

- (id)formatServerResponse:(id)serverResponse {
  NSArray *formattedResponse = serverResponse[kManyResultsKey];
  if (![formattedResponse isKindOfClass:[NSArray class]]) {
    formattedResponse = @[formattedResponse];
  }
  return formattedResponse;
}

@end
