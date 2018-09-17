//
//  UIColor+Hex.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@interface UIColor (Hex)
+ (instancetype)colorWithRGB:(uint32_t)rgb;
+ (instancetype)colorWithRGB:(uint32_t)rgb alpha:(CGFloat)alpha;
+ (instancetype)colorWithRGBString:(NSString *)rgb;
@end
