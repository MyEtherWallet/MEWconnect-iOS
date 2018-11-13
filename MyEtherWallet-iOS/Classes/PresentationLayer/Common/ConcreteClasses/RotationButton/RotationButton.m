//
//  RotationButton.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "RotationButton.h"

static CFTimeInterval const kRotationButtonDuration = 1.0;
static NSString *const kRotationButtonAnimationKey  = @"animation.rotate";

@interface RotationButton () <CAAnimationDelegate>
@end

@implementation RotationButton

- (void)setRotation:(BOOL)rotation {
  if (_rotation != rotation) {
    _rotation = rotation;
    if (_rotation) {
      self.userInteractionEnabled = NO;
      [self _addRotateAnimation];
    } else if ([self.imageView.layer animationForKey:kRotationButtonAnimationKey] == nil) {
      self.userInteractionEnabled = YES;
    }
  }
}

#pragma mark - Private

- (void) _addRotateAnimation {
  CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  rotationAnimation.toValue = @(-M_PI * 2.0);
  rotationAnimation.duration = kRotationButtonDuration;
  rotationAnimation.cumulative = YES;
  rotationAnimation.repeatCount = 1;
  rotationAnimation.delegate = self;
  
  [self.imageView.layer addAnimation:rotationAnimation forKey:kRotationButtonAnimationKey];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(__unused CAAnimation *)anim finished:(__unused BOOL)flag
{
  if (self.rotation) {
    [self _addRotateAnimation];
  } else {
    self.userInteractionEnabled = YES;
  }
}

@end
