//
//  NSBundle+Version.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSBundle+Version.h"

@implementation NSBundle (Version)
- (NSString *) applicationVersion {
  NSString *version = [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  NSString *build = [self objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
  return [NSString stringWithFormat:@"%@ (%@)", version, build];
}
@end
