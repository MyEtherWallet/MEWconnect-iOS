//
//  PasswordInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 28/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import zxcvbn_ios.DBZxcvbn;
@import CoreGraphics.CGBase;

#import "PasswordInteractor.h"

#import "PasswordInteractorOutput.h"

@implementation PasswordInteractor {
  NSArray <NSString *> *_words;
  NSString *_password;
}

#pragma mark - PasswordInteractorInput

- (void) configureWithWords:(NSArray <NSString *> *)words {
  _words = words;
}

- (void)scorePassword:(NSString *)password {
  _password = password;
  DBResult *result = [self.zxcvbn passwordStrength:password];
  [self.output updateScore:result.score];
}

- (void) confirmPassword {
  if ([_password length] > 0) {
    [self.output confirmPassword:_password words:_words];
  }
}

- (BOOL)isWordsProvided {
  return _words != nil;
}

@end
