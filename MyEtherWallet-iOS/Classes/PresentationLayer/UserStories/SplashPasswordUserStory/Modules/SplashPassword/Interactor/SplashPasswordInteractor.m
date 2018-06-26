//
//  SplashPasswordInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordInteractor.h"

#import "MEWwallet.h"

#import "SplashPasswordInteractorOutput.h"

@implementation SplashPasswordInteractor

#pragma mark - SplashPasswordInteractorInput

- (void)checkPassword:(NSString *)password {
  NSString *address = [self.walletService validatePassword:password];
  if (address) {
    [self.output correctPassword:password];
  } else {
    [self.output incorrectPassword];
  }
}

@end
