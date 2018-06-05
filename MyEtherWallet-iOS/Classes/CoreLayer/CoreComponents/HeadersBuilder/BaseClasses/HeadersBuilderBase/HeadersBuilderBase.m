//
//  HeadersBuilderBase.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 21/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "HeadersBuilderBase.h"

static NSString *const kHeaderContentTypeTitle  = @"Content-Type";
static NSString *const kHeaderAcceptTitle       = @"Accept";

static NSString *const kHeaderContentTypeValue  = @"application/json";
static NSString *const kHeaderAcceptValue       = @"application/json";

@implementation HeadersBuilderBase

- (NSDictionary *) build
{
  return @{kHeaderContentTypeTitle: kHeaderContentTypeValue,
           kHeaderAcceptTitle: kHeaderAcceptValue};
}

@end
