//
//  UIColor+Hex.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (instancetype)colorWithRGBString:(NSString *)rgb {
  NSString* colorString = [[rgb stringByReplacingOccurrencesOfString:@"#" withString: @""] uppercaseString];
  
  CGFloat alpha, red, blue, green;
  
  switch ([colorString length])
  {
    case 3: // #RGB
      alpha = 1.0f;
      red   = [self colorComponentFrom:colorString start:0 length:1];
      green = [self colorComponentFrom:colorString start:1 length:1];
      blue  = [self colorComponentFrom:colorString start:2 length:1];
      break;
    case 4: // #ARGB
      alpha = [self colorComponentFrom:colorString start:0 length:1];
      red   = [self colorComponentFrom:colorString start:1 length:1];
      green = [self colorComponentFrom:colorString start:2 length:1];
      blue  = [self colorComponentFrom:colorString start:3 length:1];
      break;
    case 6: // #RRGGBB
      alpha = 1.0f;
      red   = [self colorComponentFrom:colorString start:0 length:2];
      green = [self colorComponentFrom:colorString start:2 length:2];
      blue  = [self colorComponentFrom:colorString start:4 length:2];
      break;
    case 8: // #AARRGGBB
      alpha = [self colorComponentFrom:colorString start:0 length:2];
      red   = [self colorComponentFrom:colorString start:2 length:2];
      green = [self colorComponentFrom:colorString start:4 length:2];
      blue  = [self colorComponentFrom:colorString start:6 length:2];
      break;
    default:
      return nil;
  }
  
  return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (instancetype)colorWithRGB:(uint32_t)rgb {
  return [self colorWithRGB:rgb alpha:1.0];
}

+ (instancetype)colorWithRGB:(uint32_t)rgb alpha:(CGFloat)alpha {
  return [UIColor colorWithRed:(((rgb >> 16) & 0xFF) / 255.0)
                         green:(((rgb >> 8) & 0xFF) / 255.0)
                          blue:(((rgb >> 0) & 0xFF) / 255.0)
                         alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length
{
  NSString* substring = [string substringWithRange:NSMakeRange(start, length)];
  NSString* fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
  unsigned hexComponent;
  [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
  return hexComponent / 255.0;
}

@end
