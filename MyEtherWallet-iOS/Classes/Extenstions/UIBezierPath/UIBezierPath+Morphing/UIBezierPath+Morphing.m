//
//  UIBezierPath+Morphing.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "UIBezierPath+Morphing.h"

@implementation UIBezierPath (Morphing)
+ (instancetype) segmentedPathWithSize:(CGSize)size numberOfCorners:(NSUInteger)numberOfCorners numberOfMorphCorners:(NSUInteger)numberOfMorphCorners {
  NSAssert(numberOfCorners > 2, @"Number of corners should be greater than 2");
  NSAssert(numberOfMorphCorners >= numberOfCorners, @"Number of morph corners should be greater than number of corners");
  UIBezierPath *bezierPath = [UIBezierPath bezierPath];
  
  CGFloat angleStep = (M_PI * 2.0) / numberOfCorners;
  CGFloat midX, xRadius;
  midX = xRadius = size.width / 2.0;
  CGFloat midY, yRadius;
  midY = size.height / 2.0;
  yRadius = -1.0 * midY;
  
  NSUInteger animationCorners = (numberOfMorphCorners - numberOfCorners) / 2;
  
  CGFloat startAngle = M_PI_2;
  [bezierPath moveToPoint:CGPointMake(midX, 0.0)];
  for (NSInteger idx = 0; idx < animationCorners; ++idx) {
    [bezierPath addLineToPoint:CGPointMake(midX, 0.0)];
  }
  for (NSInteger idx = 1; idx < numberOfCorners; ++idx) {
    CGFloat angle = startAngle - angleStep * idx;
    CGFloat x = midX + xRadius * cosf(angle);
    CGFloat y = midY + yRadius * sinf(angle);
    [bezierPath addLineToPoint:CGPointMake(x, y)];
    if (idx == numberOfCorners / 2) {
      for (NSInteger idx = 0; idx < animationCorners; ++idx) {
        [bezierPath addLineToPoint:CGPointMake(x, y)];
      }
    }
  }
  [bezierPath closePath];
  return bezierPath;
}
@end
