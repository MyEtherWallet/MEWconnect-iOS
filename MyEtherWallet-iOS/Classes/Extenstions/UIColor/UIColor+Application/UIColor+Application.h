//
//  UIColor+Application.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@interface UIColor (Application)
+ (instancetype) mainApplicationColor;
+ (instancetype) placeholderColor;
+ (instancetype) weakColor;
+ (instancetype) sosoColor;
+ (instancetype) goodColor;
+ (instancetype) greatColor;
+ (instancetype) barButtonColorForState:(UIControlState)state;
+ (instancetype) darkTextColor;
+ (instancetype) applicationLightBlue;
+ (instancetype) backgroundLightBlue;
+ (instancetype) lightGreyTextColor;
@end
