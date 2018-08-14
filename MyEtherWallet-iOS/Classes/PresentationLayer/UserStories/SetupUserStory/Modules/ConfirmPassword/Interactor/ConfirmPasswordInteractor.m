//
//  ConfirmPasswordInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 01/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ConfirmPasswordInteractor.h"

#import "ConfirmPasswordInteractorOutput.h"

@implementation ConfirmPasswordInteractor {
  NSString *_password;
  NSArray <NSString *> *_words;
}

#pragma mark - ConfirmPasswordInteractorInput

- (void) configurateWithPassword:(NSString *)password words:(NSArray<NSString *> *)words {
  _password = password;
  _words = words;
}

- (void) complareConfirmationPassword:(NSString *)password {
  if ([password length] > 0) {
    if ([_password isEqualToString:password]) {
      [self.output correctPasswords];
    } else {
      [self.output incorrectPassword:NO];
    }
  } else {
    [self.output emptyConfirmationPassword];
  }
}

- (void) confirmPasswordWithPassword:(NSString *)password {
  if ([password length] > 0 && [_password isEqualToString:password]) {
    [self.output prepareWalletWithPassword:_password words:_words];
  } else {
    [self.output incorrectPassword:YES];
  }
}

@end
