//
//  PasswordTextField.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "PasswordTextField.h"
#import "UIColor+Application.h"
#import "UIImage+Color.h"

static CGFloat kPasswordTextFieldTextInset = 14.0;
static CGFloat kPasswordTextFieldCaretHeight = 24.0;

@implementation PasswordTextField

- (void)awakeFromNib {
  [super awakeFromNib];
  
  NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", @"Password text field placeholder")
                                                                              attributes:@{NSForegroundColorAttributeName: [UIColor placeholderColor]}];
  [self setAttributedPlaceholder:attributedPlaceholder];
}

#pragma mark - Public

- (void)setTheme:(PasswordTextFieldTheme)theme {
  if (_theme != theme) {
    _theme = theme;
    switch (theme) {
      case PasswordTextFieldThemeDefault: {
        /* Password text field */
        [self setBackground:[[PasswordTextField appearance] background]];
        break;
      }
      case PasswordTextFieldThemeRed: {
        UIImage *background = [[UIImage imageWithColor:[UIColor weakColor]
                                                  size:CGSizeMake(48.0f, 48.0f)
                                          cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(24.0f, 24.0f, 24.0f, 24.0f)];
        [self setBackground:background];
        break;
      }
        
      default:
        break;
    }
  }
}

#pragma mark - Insets

- (CGRect)textRectForBounds:(CGRect)bounds {
  CGRect rect = CGRectInset(bounds, kPasswordTextFieldTextInset, 0.0f);
  rect.origin.y += 1.0;
  return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  CGRect rect = CGRectInset(bounds, kPasswordTextFieldTextInset, 0.0f);
  rect.origin.y += 1.0;
  return rect;
}

#pragma mark - Caret

- (CGRect)caretRectForPosition:(UITextPosition *)position {
  CGRect caretRect = [super caretRectForPosition:position];
  CGFloat height = CGRectGetHeight(caretRect);
  caretRect.origin.y -= (kPasswordTextFieldCaretHeight - height) / 2.0;
  caretRect.origin.y += 1.0;
  caretRect.size.height = kPasswordTextFieldCaretHeight;
  return caretRect;
}

@end
