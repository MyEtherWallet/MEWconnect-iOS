//
//  UIImage+Color.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners borderColor:(UIColor *)borderColor borderSize:(CGFloat)borderSize insets:(UIEdgeInsets)insets
{
  CGRect rect = CGRectZero;
  rect.size = size;
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, [color CGColor]);
  BOOL stroke = borderColor && borderSize > 0.0;
  if (stroke) {
    CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
  }
  CGRect drawRect = CGRectMake(insets.left, insets.top, CGRectGetWidth(rect) - insets.left - insets.right, CGRectGetHeight(rect) - insets.top - insets.bottom);
  if (cornerRadius > 0.0) {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:drawRect byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    [bezierPath fill];
    if (stroke) {
      UIBezierPath *strokeBezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(drawRect, borderSize / 2.0, borderSize / 2.0) byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
      strokeBezierPath.lineWidth = borderSize;
      [strokeBezierPath stroke];
    }
  } else {
    CGContextFillRect(context, drawRect);
  }
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
  UIGraphicsEndImageContext();
  
  return image;
}

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderSize:(CGFloat)borderSize {
  return [self imageWithColor:color size:size cornerRadius:cornerRadius corners:UIRectCornerAllCorners borderColor:borderColor borderSize:borderSize insets:UIEdgeInsetsZero];
}

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners {
  return [self imageWithColor:color size:size cornerRadius:cornerRadius corners:corners borderColor:nil borderSize:0.0 insets:UIEdgeInsetsZero];
}

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius insets:(UIEdgeInsets)insets
{
  return [self imageWithColor:color size:size cornerRadius:cornerRadius corners:UIRectCornerAllCorners borderColor:nil borderSize:0.0 insets:insets];
}

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
  return [self imageWithColor:color size:size cornerRadius:cornerRadius corners:UIRectCornerAllCorners];
}

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size
{
  return [self imageWithColor:color size:size cornerRadius:0.0];
}

+ (UIImage *) imageWithColor:(UIColor *)color
{
  return [self imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

@end
