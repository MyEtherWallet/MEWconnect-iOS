//
//  NSString+HexData.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSString+HexData.h"

@implementation NSString (HexData)
- (NSData *) parseHexData {
  NSString *pattern = @".{1,2}";
  
  NSError *error = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options: 0 error: &error];
  
  NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
  
  NSMutableData *result = [[NSMutableData alloc] init];
  NSInteger i = 0;
  for (NSTextCheckingResult *match in matches) {
    NSString *part = [self substringWithRange:match.range];
    NSScanner *scanner = [NSScanner scannerWithString:part];
    unsigned int hex = 0;
    [scanner scanHexInt:&hex];
    
    UInt8 uintHex = hex;
    [result appendBytes:&uintHex length:sizeof(UInt8)];
    ++i;
  }
  return result;
}
@end
