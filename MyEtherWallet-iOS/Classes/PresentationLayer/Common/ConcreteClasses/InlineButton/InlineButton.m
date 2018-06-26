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
  InlineButton *button = [InlineButton buttonWithType:UIButtonTypeSystem];
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
  frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) -  self.imageEdgeInsets.right + self.imageEdgeInsets.left;
  frame.origin.y += self.imageEdgeInsets.top;
  return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
  CGRect frame = [super titleRectForContentRect:contentRect];
  frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth([self imageRectForContentRect:contentRect]);
  return frame;
}

@end
