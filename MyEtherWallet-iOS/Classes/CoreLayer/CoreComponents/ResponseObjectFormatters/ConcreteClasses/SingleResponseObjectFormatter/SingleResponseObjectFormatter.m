//
//  SingleResponseObjectFormatter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SingleResponseObjectFormatter.h"

static NSString *const kManyResultsKey = @"result";

@implementation SingleResponseObjectFormatter

- (id)formatServerResponse:(id)serverResponse {
  id formattedResponse = serverResponse[kManyResultsKey];
  if ([formattedResponse isKindOfClass:[NSArray class]]) {
    formattedResponse = [((NSArray *)formattedResponse) firstObject];
  }
  return formattedResponse;
}

@end
