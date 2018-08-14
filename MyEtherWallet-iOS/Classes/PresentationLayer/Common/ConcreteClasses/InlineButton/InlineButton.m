//
//  InlineButton.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InlineButton.h"

@implementation InlineButton

+ (instancetype) inlineButtonWithChevron:(BOOL)chevron {
  InlineButton *button = [[self class] buttonWithType:UIButtonTypeSystem];
  button.tintColor = [UIColor whiteColor];
  //TODO: Uncomment when available new UI
  if (chevron) {
    UIImage *icon = [UIImage imageNamed:@"inline_small_chevron"];
    [button setImage:icon forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
  }
  return button;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
  CGRect frame = [super imageRectForContentRect:contentRect];
  CGRect titleRect = [self titleRectForContentRect:contentRect];
  frame.origin.x = CGRectGetMaxX(titleRect) - self.imageEdgeInsets.right + self.imageEdgeInsets.left;
  frame.origin.y += self.imageEdgeInsets.top;
  return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
  CGRect frame = [super titleRectForContentRect:contentRect];
  UIImage *image = [self imageForState:self.state];
  CGFloat imageWidth = 0.0;
  if (image) {
    imageWidth = image.size.width;
  }
  frame.origin.x = CGRectGetMinX(frame) - imageWidth;
  return frame;
}

@end
