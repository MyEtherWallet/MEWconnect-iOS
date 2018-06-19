//
//  UIColor+Application.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "UIColor+Application.h"
#import "UIColor+Hex.h"

@implementation UIColor (Application)

+ (instancetype) mainApplicationColor {
  return [UIColor colorWithRGB:0x064DD6];
}

+ (instancetype) placeholderColor {
  return [UIColor colorWithRGB:0xFFFFFF alpha:0.3];
}

+ (instancetype) weakColor {
  return [UIColor colorWithRGB:0xD60606];
}

+ (instancetype) sosoColor {
  return [UIColor colorWithRGB:0xE8A800];
}

+ (instancetype) goodColor {
  return [UIColor colorWithRGB:0x11D252];
}

+ (instancetype) greatColor {
  return [self mainApplicationColor];
}

+ (instancetype) barButtonColorForState:(UIControlState)state {
  switch (state) {
    case UIControlStateNormal: {
      return [self mainApplicationColor];
      break;
    }
    case UIControlStateDisabled: {
      return [UIColor colorWithRGB:0x9B9B9B];
      break;
    }
    default:
      break;
  }
  return [UIColor blackColor];
}

+ (instancetype)darkTextColor {
  return [UIColor colorWithRGB:0x212121];
}

+ (instancetype)applicationLightBlue {
  return [UIColor colorWithRGB:0xF2F4F7];
}

+ (instancetype) backgroundLightBlue {
  return [UIColor colorWithRGB:0xEBF1FC];
}

+ (instancetype) lightGreyTextColor {
  return [UIColor colorWithRGB:0x6E7384];
}
@end
