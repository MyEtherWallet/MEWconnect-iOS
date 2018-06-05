//
//  TokensResponseObjectFormatter.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TokensResponseObjectFormatter.h"

static NSString *const kTokensResultsKey = @"result";

@implementation TokensResponseObjectFormatter

- (id)formatServerResponse:(id)serverResponse {
  NSArray *formattedResponse = serverResponse[kTokensResultsKey];
  return formattedResponse;
}

@end
