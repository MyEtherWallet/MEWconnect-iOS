//
//  PasswordTextField.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(short, PasswordTextFieldTheme) {
  PasswordTextFieldThemeDefault,
  PasswordTextFieldThemeRed,
  PasswordTextFieldThemeDisabled,
};

@interface PasswordTextField : UITextField
@property (nonatomic) PasswordTextFieldTheme theme;
@property (nonatomic) BOOL inputEnabled;
- (void) setRightViewText:(NSString *)text;
@end
