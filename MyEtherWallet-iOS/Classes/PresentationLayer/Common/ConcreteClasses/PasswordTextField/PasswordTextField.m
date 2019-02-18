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

static CGFloat kPasswordTextFieldTextInset        = 14.0;
static CGFloat kPasswordTextFieldCaretHeight      = 24.0;
static CGFloat kPasswordTextFieldRightLabelWidth  = 100.0;

@interface PasswordTextField()
@property (nonatomic, weak) UILabel *rightLabel;
@end

@implementation PasswordTextField {
  NSAttributedString *_originalPlaceholder;
  NSString *_lastRightLabelText;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  _inputEnabled = YES;
  NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", @"Password text field placeholder")
                                                                              attributes:@{NSForegroundColorAttributeName: [UIColor placeholderColor]}];
  [self setAttributedPlaceholder:attributedPlaceholder];
  self.enablesReturnKeyAutomatically = YES;
  [self _updateRightView];
}

#pragma mark - Public

- (void)setTheme:(PasswordTextFieldTheme)theme {
  if (_theme != theme) {
    _theme = theme;
    switch (theme) {
      case PasswordTextFieldThemeDefault: {
        self.tintColor = ((PasswordTextField *)[[self class] appearance]).tintColor;
        /* Password text field */
        [self setBackground:[[PasswordTextField appearance] background]];
        if (_originalPlaceholder) {
          [self setAttributedPlaceholder:_originalPlaceholder];
        }
        break;
      }
      case PasswordTextFieldThemeRed: {
        UIImage *background = [[UIImage imageWithColor:[UIColor weakColor]
                                                  size:CGSizeMake(48.0f, 48.0f)
                                          cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(24.0f, 24.0f, 24.0f, 24.0f)];
        [self setBackground:background];
        break;
      }
      case PasswordTextFieldThemeDisabled: {
        self.tintColor = [UIColor clearColor];
        NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Please wait", @"Password text field placeholder. Locked state")
                                                                                    attributes:@{NSForegroundColorAttributeName: [UIColor disabledPlaceholderColor]}];
        [self setAttributedPlaceholder:attributedPlaceholder];
        
        UIImage *background = [[UIImage imageWithColor:[UIColor disabledBackgroundColor]
                                                  size:CGSizeMake(48.0f, 48.0f)
                                          cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(24.0f, 24.0f, 24.0f, 24.0f)];
        [self setBackground:background];
      }
      default:
        break;
    }
  }
}

- (void) setRightViewText:(NSString *)text {
  _lastRightLabelText = text;
  [self.rightLabel setText:text];
}

#pragma mark - Override

- (void) setInputEnabled:(BOOL)enabled {
  BOOL wasEnabled = _inputEnabled;
  _inputEnabled = enabled;
  if (wasEnabled != enabled) {
    if (enabled) {
      [self setTheme:PasswordTextFieldThemeDefault];
      self.rightViewMode = UITextFieldViewModeNever;
    } else {
      [self setTheme:PasswordTextFieldThemeDisabled];
      self.rightViewMode = UITextFieldViewModeAlways;
    }
  }
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
  [super setAttributedPlaceholder:attributedPlaceholder];
  if (_inputEnabled) {
    _originalPlaceholder = attributedPlaceholder;
  }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  if (!_inputEnabled) {
    return NO;
  }
  return [super canPerformAction:action withSender:sender];
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

#pragma mark - Private

- (void) _updateRightView {
  if (!self.rightView) {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kPasswordTextFieldRightLabelWidth, CGRectGetHeight(self.bounds))];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = _lastRightLabelText;
    label.font = [UIFont monospacedDigitSystemFontOfSize:17.0 weight:UIFontWeightRegular];
    label.textColor = [UIColor disabledPlaceholderColor];
    label.textAlignment = NSTextAlignmentRight;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:label];
    [NSLayoutConstraint activateConstraints:
     @[[container.leadingAnchor constraintEqualToAnchor:label.leadingAnchor],
       [container.topAnchor constraintEqualToAnchor:label.topAnchor],
       [container.bottomAnchor constraintEqualToAnchor:label.bottomAnchor],
       [container.trailingAnchor constraintEqualToAnchor:label.trailingAnchor constant:14.0]
       ]];
    self.rightLabel = label;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.rightView = container;
  }
}

@end
