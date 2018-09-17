//
//  NSString+Hex.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 22/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "NSString+Hex.h"

@implementation NSString (Hex)
- (NSString *) parseHexString {
  NSString *pattern = @".{1,2}";
  
  NSError *error = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options: 0 error: &error];
  
  NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
  
  NSMutableString *result = [[NSMutableString alloc] initWithCapacity:[self length] / 2];
  for (NSTextCheckingResult *match in matches) {
    NSString *hexChar = [self substringWithRange:match.range];
    int value = 0;
    sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
    [result appendFormat:@"%c", (char)value];
  }
  return result;
}

- (NSUInteger)parseHexUInt {
  unsigned int value;
  
  NSScanner *countTokensScanner = [NSScanner scannerWithString:self];
  [countTokensScanner scanHexInt:&value];
  
  return value;
}
@end
