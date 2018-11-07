//
//  UIScreen+AnimateBrightness.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "UIScreen+AnimateBrightness.h"

static double const kUIScreenTicksPerSecond = 60;

@implementation UIScreen (AnimateBrightness)

- (CGFloat) animateBrightnessTo:(CGFloat)newBrightness withDuration:(NSTimeInterval)duration {
  CGFloat startBrightness = self.brightness;
  CGFloat delta = newBrightness - startBrightness;
  NSInteger totalTicks = kUIScreenTicksPerSecond * duration;
  CGFloat changePerTick = delta / totalTicks;
  CGFloat delayBetweenTicks = 1.0 / kUIScreenTicksPerSecond;
  
  self.brightness += changePerTick;
  
  dispatch_queue_t queue;
  dispatch_queue_attr_t attr;
  attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, 0);
  queue = dispatch_queue_create("com.myetherwallet.queue.brightnessanimation", attr);
  
  @weakify(self);
  dispatch_async(queue, ^{
    @strongify(self);
    for (NSInteger i = 2; i <= totalTicks; ++i) {
      [NSThread sleepForTimeInterval:delayBetweenTicks];
      CGFloat nextValue = MAX(0.0, MIN(1.0, self.brightness + changePerTick));
      
      self.brightness = nextValue;
    }
  });
  return startBrightness;
}

@end
