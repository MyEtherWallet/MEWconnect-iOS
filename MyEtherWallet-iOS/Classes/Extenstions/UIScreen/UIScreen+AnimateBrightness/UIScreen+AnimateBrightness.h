//
//  UIScreen+AnimateBrightness.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/10/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@interface UIScreen (AnimateBrightness)
- (CGFloat) animateBrightnessTo:(CGFloat)newBrightness withDuration:(NSTimeInterval)duration;
@end

