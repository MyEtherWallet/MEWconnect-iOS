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
#import "UIView+LockAlpha.h"
#import "UIScreen+ScreenSizeType.h"

@interface FlatButton ()
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation FlatButton {
  NSAttributedString *_normalTitle;
  NSAttributedString *_disabledTitle;
}

- (void)setTheme:(short /*FlatButtonTheme*/)theme {
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
  
- (void) setCompact:(BOOL)compact {
  if (_compact != compact) {
    _compact = compact;
    self.alternativeDisabledTheme = self.alternativeDisabledTheme;
    FlatButtonTheme theme = self.theme;
    _theme = FlatButtonThemeUnknown;
    self.theme = theme;
  }
}
  
- (void) setLoading:(BOOL)loading {
  if (_loading != loading) {
    _loading = loading;
    if (_loading) {
      self.userInteractionEnabled = NO;
      _normalTitle = [self attributedTitleForState:UIControlStateNormal];
      _disabledTitle = [self attributedTitleForState:UIControlStateDisabled];
      UIActivityIndicatorViewStyle indicatorStyle = self.enabled ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray;
      UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
      activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
      [self addSubview:activityIndicator];
      [activityIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
      [activityIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
      activityIndicator.alpha = 0.0;
      self.activityIndicatorView = activityIndicator;
      [self.activityIndicatorView startAnimating];
      [UIView animateWithDuration:0.3
                            delay:0.0
                          options:UIViewAnimationOptionBeginFromCurrentState
                       animations:^{
                         self.titleLabel.alpha = 0.0;
                         self.activityIndicatorView.alpha = 1.0;
                         self.titleLabel.lockAlpha = YES;
                       } completion:nil];
    } else {
      [UIView animateWithDuration:0.3
                            delay:0.0
                          options:UIViewAnimationOptionBeginFromCurrentState
                       animations:^{
                         self.titleLabel.lockAlpha = NO;
                         self.titleLabel.alpha = 1.0;
                         self.activityIndicatorView.alpha = 0.0;
                       } completion:^(__unused BOOL finished) {
                         [self.activityIndicatorView removeFromSuperview];
                         self.userInteractionEnabled = YES;
                       }];
    }
  }
}
  
- (void) setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  if (self.activityIndicatorView) {
    UIActivityIndicatorViewStyle indicatorStyle = self.enabled ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray;
    self.activityIndicatorView.activityIndicatorViewStyle = indicatorStyle;
  }
  
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
  if (title) {
    UIColor *textColor = [self titleColorForState:state];
    if (!textColor) {
      textColor = [self titleColorForState:UIControlStateNormal];
    }
    NSDictionary *attributes = @{NSFontAttributeName: self.titleLabel.font,
                                 NSForegroundColorAttributeName: textColor,
                                 NSKernAttributeName: @(0.5)};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    [self setAttributedTitle:attributedTitle forState:state];
  } else {
    [self setAttributedTitle:nil forState:state];
  }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
  CGRect rect = [super imageRectForContentRect:contentRect];
  if (self.defineImageRect) {
    CGFloat offset = (CGRectGetHeight(contentRect) - CGRectGetHeight(rect)) / 2.0;
    offset += self.imageEdgeInsets.left;
    rect.origin.x = offset;
  }
  return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
  CGRect rect = [super titleRectForContentRect:contentRect];
  if (self.defineImageRect) {
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    rect.origin.x -= CGRectGetWidth(imageRect) / 2.0;
  }
  return rect;
}

@end
