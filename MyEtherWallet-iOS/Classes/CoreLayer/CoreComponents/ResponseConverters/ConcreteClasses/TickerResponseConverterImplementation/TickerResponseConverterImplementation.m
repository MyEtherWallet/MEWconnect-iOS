//
//  TickerResponseConverterImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "TickerResponseConverterImplementation.h"

static NSString *const kTickerResponseData  = @"data";
static NSString *const kTickerResult        = @"result";

@implementation TickerResponseConverterImplementation

- (id)convertFromResponse:(id)response error:(NSError *__autoreleasing *)error {
  if ([response isKindOfClass:[NSDictionary class]]) {
    NSDictionary *tickerData = response[kTickerResponseData];
    if ([tickerData isKindOfClass:[NSDictionary class]]) {
      NSMutableArray *ticker = [[NSMutableArray alloc] initWithCapacity:[tickerData count]];
      [tickerData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [ticker addObject:obj];
      }];
      return @{kTickerResult: ticker};
    } else if ([tickerData isKindOfClass:[NSArray class]]) {
      return @{kTickerResult: tickerData};
    }
  }
  return @{kTickerResult: response};
}

@end
