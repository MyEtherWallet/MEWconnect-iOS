//
//  FlatButton.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(short, FlatButtonTheme) {
  FlatButtonThemeUnknown    = 0,
  FlatButtonThemeMain       = 1,
  FlatButtonThemeWhite      = 2,
  FlatButtonThemeLightRed   = 3,
  FlatButtonThemeLightBlue  = 4,
};

@interface FlatButton : UIButton
#if TARGET_INTERFACE_BUILDER
@property (nonatomic) IBInspectable short theme;
#else
@property (nonatomic) IBInspectable FlatButtonTheme theme;
#endif
@property (nonatomic) IBInspectable BOOL alternativeDisabledTheme;
@property (nonatomic) IBInspectable BOOL compact;
@end
