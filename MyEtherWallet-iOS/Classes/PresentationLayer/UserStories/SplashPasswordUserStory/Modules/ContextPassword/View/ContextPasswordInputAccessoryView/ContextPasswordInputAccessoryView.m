//
//  ContextPasswordInputAccessoryView.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ContextPasswordInputAccessoryView.h"

#import "UIImage+Color.h"

static CGFloat const ContextPasswordInputAccessoryViewHeight        = 137.0;
static CGFloat const ContextPasswordInputAccessoryViewCornerRadius  = 12.0;

@interface ContextPasswordInputAccessoryView ()
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@end

@implementation ContextPasswordInputAccessoryView

- (void)awakeFromNib {
  [super awakeFromNib];
  CGFloat size = ContextPasswordInputAccessoryViewCornerRadius * 2.0 + 10.0;
  CGFloat halfSize = size / 2.0;
  UIImage *backgroundImage = [[UIImage imageWithColor:[UIColor whiteColor]
                                                 size:CGSizeMake(size, size)
                                         cornerRadius:ContextPasswordInputAccessoryViewCornerRadius
                                              corners:UIRectCornerTopLeft|UIRectCornerTopRight]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(halfSize, halfSize, halfSize, halfSize)];
  self.backgroundImageView.image = backgroundImage;
}

- (CGSize)intrinsicContentSize {
  return CGSizeMake(UIViewNoIntrinsicMetric, ContextPasswordInputAccessoryViewHeight);
}

@end
