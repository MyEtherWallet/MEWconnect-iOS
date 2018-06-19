//
//  NSArray+Data.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSArray+Data.h"

@implementation NSArray (Data)

- (NSData *) convertToData {
  NSMutableData *data = [[NSMutableData alloc] initWithCapacity:[self count]];
  for (NSNumber *byteNumber in self) {
    uint8_t byte = [byteNumber unsignedCharValue];
    [data appendBytes:&byte length:sizeof(uint8_t)];
  }
  return [data copy];
}

@end
