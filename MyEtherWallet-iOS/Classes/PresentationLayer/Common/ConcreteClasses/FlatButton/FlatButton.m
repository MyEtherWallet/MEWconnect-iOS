//
//  FlatButton.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "FlatButton.h"
#import "UIColor+Application.h"
#import "UIImage+Color.h"
#import "UIColor+Hex.h"
#import "UIScreen+ScreenSizeType.h"

@implementation FlatButton

#if TARGET_INTERFACE_BUILDER
- (void)setTheme:(short)theme {
#else
- (void)setTheme:(FlatButtonTheme)theme {
#endif
  if (_theme != theme) {
    _theme = theme;
    UIColor *backgroundColor = nil;
    UIColor *textColor = nil;
    switch (_theme) {
      case FlatButtonThemeWhite: {
        backgroundColor = [UIColor whiteColor];
        textColor = [UIColor mainApplicationColor];
        break;
      }
      case FlatButtonThemeMain: {
        backgroundColor = [UIColor mainApplicationColor];
        textColor = [UIColor whiteColor];
        break;
      }
      case FlatButtonThemeLightRed: {
        backgroundColor = [UIColor colorWithRGB:0xFAE6E6];
        textColor = [UIColor weakColor];
        break;
      }
      case FlatButtonThemeLightBlue: {
        backgroundColor = [[UIColor mainApplicationColor] colorWithAlphaComponent:0.08];
        textColor = [UIColor mainApplicationColor];
        break;
      }
      case FlatButtonThemeUnknown:
      default: {
        break;
      }
    }
    CGFloat size = 56.0;
    if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40 && self.compact) {
      size = 44.0;
    }
    CGFloat halfSize = size / 2.0;
    UIImage *background = [[UIImage imageWithColor:backgroundColor
                                              size:CGSizeMake(size, size)
                                      cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(halfSize, halfSize, halfSize, halfSize)];
    
    [self setBackgroundImage:background forState:UIControlStateNormal];
    [self setTitleColor:textColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    [UIView performWithoutAnimation:^{
      [self setTitle:[self titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    }];
  }
}
  
- (void) setAlternativeDisabledTheme:(BOOL)alternativeDisabledTheme {
  _alternativeDisabledTheme = alternativeDisabledTheme;
  UIImage *disabledBackground;
  UIColor *textColor = nil;
  CGFloat size = 56.0;
  if ([UIScreen mainScreen].screenSizeType == ScreenSizeTypeInches40 && self.compact) {
    size = 44.0;
  }
  CGFloat halfSize = size / 2.0;
  if (_alternativeDisabledTheme) {
    disabledBackground = [[UIImage imageWithColor:[UIColor colorWithRGB:0xEBEDF0]
                                             size:CGSizeMake(size, size)
                                     cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(halfSize, halfSize, halfSize, halfSize)];
    textColor = [[UIColor lightGreyTextColor] colorWithAlphaComponent:0.29];
  } else {
    disabledBackground = [[UIImage imageWithColor:[UIColor colorWithRGB:0xF0F1F2]
                                             size:CGSizeMake(size, size)
                                     cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(halfSize, halfSize, halfSize, halfSize)];
    textColor = [[UIColor lightGreyTextColor] colorWithAlphaComponent:0.2];
  }
  [self setBackgroundImage:disabledBackground forState:UIControlStateDisabled];
  [self setTitleColor:textColor forState:UIControlStateDisabled];
  [UIView performWithoutAnimation:^{
    [self setTitle:[self titleForState:UIControlStateDisabled] forState:UIControlStateDisabled];
  }];
}
  
- (void)setCompact:(BOOL)compact {
  if (_compact != compact) {
    _compact = compact;
    self.alternativeDisabledTheme = self.alternativeDisabledTheme;
    FlatButtonTheme theme = self.theme;
    _theme = FlatButtonThemeUnknown;
    self.theme = theme;
  }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
  UIColor *textColor = [self titleColorForState:state];
  if (!textColor) {
    textColor = [self titleColorForState:UIControlStateNormal];
  }
  NSDictionary *attributes = @{NSFontAttributeName: self.titleLabel.font,
                               NSForegroundColorAttributeName: textColor,
                               NSKernAttributeName: @(0.5)};
  NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
  [self setAttributedTitle:attributedTitle forState:state];
}

@end
