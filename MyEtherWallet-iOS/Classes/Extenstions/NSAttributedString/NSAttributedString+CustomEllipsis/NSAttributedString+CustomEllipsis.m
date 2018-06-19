//
//  NSAttributedString+CustomEllipsis.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "NSAttributedString+CustomEllipsis.h"

@implementation NSAttributedString (CustomEllipsis)

- (instancetype) truncatedAttributedStringWithCustomEllipsis:(NSAttributedString *)ellipsis maxSize:(CGSize)maxSize truncationPosition:(NSInteger)position {
  NSAssert(position > 0 && position < [self length], @"Position should be in range [0 ... string lenght]");
  CGSize fullSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
  CGRect boundingRect = [self boundingRectWithSize:fullSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
  NSMutableAttributedString *mutableAttributedString;
  while (CGRectGetWidth(boundingRect) > maxSize.width ||
         CGRectGetHeight(boundingRect) > maxSize.height) {
    
    NSRange replaceRange;
    if (!mutableAttributedString) {
      mutableAttributedString = [self mutableCopy];
      replaceRange = NSMakeRange([mutableAttributedString length] - position, 1);
    } else {
      replaceRange = NSMakeRange([mutableAttributedString length] - position - 1, 2);
    }
    if (!NSEqualRanges(replaceRange, NSIntersectionRange(replaceRange, NSMakeRange(0, [mutableAttributedString length])))) {
      return [mutableAttributedString copy];
    }
    
    [mutableAttributedString replaceCharactersInRange:replaceRange withAttributedString:ellipsis];
    boundingRect = [mutableAttributedString boundingRectWithSize:fullSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
  }
  if (!mutableAttributedString) {
    return self;
  }
  return [mutableAttributedString copy];
}

//+ (bool) replaceElipsesForLabel:(UILabel*) label With:(NSString*) replacement MaxWidth:(float) width {
//
//  CGRect origSize = label.frame;
//
//  float useWidth = width;
//
//  if(width <= 0)
//    useWidth = origSize.size.width; //use label width by default if width <= 0
//
//  [label sizeToFit];
//  CGSize labelSize = [label.text sizeWithFont:label.font];
//
//  if(labelSize.width > useWidth) {
//
//    original = label.text;
//    truncateWidth = useWidth;
//    font = label.font;
//    subLength = label.text.length;
//
//    NSString *temp = [label.text substringToIndex:label.text.length-1];
//    temp = [temp substringToIndex:[self getTruncatedStringPoint:subLength]];
//    temp = [NSString stringWithFormat:@"%@%@", temp, replacement];
//
//    int count = 0;
//
//    while([temp sizeWithFont:label.font].width > useWidth){
//
//      count++;
//
//      temp = [label.text substringToIndex:(label.text.length-(1+count))];
//      temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; //remove this if you want to keep whitespace on the end
//      temp = [NSString stringWithFormat:@"%@%@", temp, replacement];
//    }
//
//    label.text = temp;
//    label.frame = origSize;
//    return true;
//  }
//  else {
//    label.frame = origSize;
//    return false;
//  }
//}
//
//+ (int) getTruncatedStringPoint:(int) splitPoint {
//
//  NSString *splitLeft = [original substringToIndex:splitPoint];
//  subLength /= 2;
//
//  if(subLength <= 0)
//    return splitPoint;
//
//  if([splitLeft sizeWithFont:font].width > truncateWidth){
//    return [self getTruncatedStringPoint:(splitPoint - subLength)];
//  }
//  else if ([splitLeft sizeWithFont:font].width < truncateWidth) {
//    return [self getTruncatedStringPoint:(splitPoint + subLength)];
//  }
//  else {
//    return splitPoint;
//  }
//}

@end
