//
//  NSString+RCFCapitalization.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSString+RCFCapitalization.h"

@implementation NSString (RCFCapitalization)

- (NSString *)rcf_decapitalizedStringSavingCase {
  if (!self.length) {
    return self;
  }
  NSString *firstSymbol = [self substringToIndex:1];
  return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstSymbol.lowercaseString];
}

@end
