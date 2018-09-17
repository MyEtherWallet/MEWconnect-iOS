//
//  BottomImageButton.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 14/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BottomImageButton.h"

@implementation BottomImageButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
  CGRect frame = [super imageRectForContentRect:contentRect];
  frame.origin.x = CGRectGetMidX(contentRect) - CGRectGetWidth(frame) / 2.0;
  frame.origin.y = CGRectGetHeight([self titleRectForContentRect:contentRect]) + self.imageEdgeInsets.top;
  return CGRectIntegral(frame);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
  CGRect frame = [super titleRectForContentRect:contentRect];
  frame.size.width = CGRectGetWidth(contentRect);
  frame.origin.x = CGRectGetMidX(contentRect) - CGRectGetWidth(frame) / 2.0;
  frame.origin.y = 0.0;
  return CGRectIntegral(frame);
}

- (CGSize)intrinsicContentSize {
  CGRect dummyContentRect = CGRectMake(0.0, 0.0, 1000.0, 1000.0);
  CGRect imageRect = CGRectIntegral([super imageRectForContentRect:dummyContentRect]);
  CGRect titleRect = CGRectIntegral([super titleRectForContentRect:dummyContentRect]);
  CGSize size = CGSizeMake(ceilf(MAX(CGRectGetWidth(imageRect), CGRectGetWidth(titleRect))),
                           ceilf(CGRectGetHeight(imageRect) + CGRectGetHeight(titleRect)));
  size.height += self.imageEdgeInsets.top;
  size.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
  size.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right;
  return size;
}

@end
