//
//  UIScreen+ScreenSizeType.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 16/07/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "UIScreen+ScreenSizeType.h"
#import "UIScreen+ScreenScaleType.h"

@implementation UIScreen (ScreenSizeType)

- (ScreenSizeType) screenSizeType {
  CGSize size = self.bounds.size;
  CGFloat screenHeight = MAX(size.height, size.width);
  if (fabs(screenHeight - 480.0) < DBL_EPSILON) {
    return ScreenSizeTypeInches35;
  } else if (fabs(screenHeight - 568.0) < DBL_EPSILON) {
    return ScreenSizeTypeInches40;
  } else if (fabs(screenHeight - 667.0) < DBL_EPSILON) {
    return [self scaleType] == ScreenScaleTypex3 ? ScreenSizeTypeInches55 : ScreenSizeTypeInches47;
  } else if (fabs(screenHeight - 736.0) < DBL_EPSILON) {
    return ScreenSizeTypeInches55;
  } else if (fabs(screenHeight - 812.0) < DBL_EPSILON) {
    return ScreenSizeTypeInches58;
  } else {
    return ScreenSizeTypeUnknown;
  }
}

@end
