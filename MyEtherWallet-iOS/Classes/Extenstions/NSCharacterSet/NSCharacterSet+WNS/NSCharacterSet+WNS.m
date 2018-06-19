//
//  NSCharacterSet+WNS.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 25/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSCharacterSet+WNS.h"

static NSCharacterSet *_characterSet = nil;

@implementation NSCharacterSet (WNS)

+ (NSCharacterSet *) whitespaceAndSpaceAndNewlineCharacterSet
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSMutableCharacterSet *characterSet = [[NSMutableCharacterSet alloc] init];
    [characterSet addCharactersInString:@" "];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _characterSet = [characterSet copy];
  });
  return _characterSet;
}

@end
