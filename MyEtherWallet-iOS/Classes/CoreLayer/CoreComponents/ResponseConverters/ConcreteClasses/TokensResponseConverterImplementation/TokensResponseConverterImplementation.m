//
//  TokensResponseConverterImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TokensResponseConverterImplementation.h"
#import "NSString+MEWTokens.h"

static NSString *const kTokensResultKey = @"result";

@implementation TokensResponseConverterImplementation

- (id)convertFromResponse:(id)response error:(__unused NSError *__autoreleasing *)error {
  if ([response isKindOfClass:[NSArray class]]) {
    NSMutableArray *convertedResponse = [[NSMutableArray alloc] initWithCapacity:[(NSArray *)response count]];
    for (NSDictionary *request in response) {
      NSMutableDictionary *convertedRequest = [request mutableCopy];
      convertedRequest[kTokensResultKey] = [request[kTokensResultKey] decodeMEWTokens];
      [convertedResponse addObject:convertedRequest];
    }
    return [convertedResponse copy];
  } else if ([response isKindOfClass:[NSDictionary class]]) {
    NSMutableDictionary *convertedRequest = [response mutableCopy];
    convertedRequest[kTokensResultKey] = [response[kTokensResultKey] decodeMEWTokens];
    return [convertedRequest copy];
  }
  return response;
}

@end
