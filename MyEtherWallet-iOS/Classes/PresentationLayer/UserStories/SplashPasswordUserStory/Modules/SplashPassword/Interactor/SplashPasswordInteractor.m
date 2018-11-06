//
//  SplashPasswordInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 26/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "SplashPasswordInteractor.h"

#import "AccountsService.h"
#import "MEWwallet.h"
#import "Ponsomizer.h"

#import "NetworkPlainObject.h"
#import "AccountPlainObject.h"

#import "SplashPasswordInteractorOutput.h"

@interface SplashPasswordInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@end

@implementation SplashPasswordInteractor

#pragma mark - SplashPasswordInteractorInput

- (void) configurateWithAccount:(AccountPlainObject *)account {
  self.account = account;
}

- (AccountPlainObject *) obtainAccount {
  return self.account;
}

- (void)checkPassword:(NSString *)password {
  BOOL validated = [self.walletService validatePassword:password account:self.account];
  if (validated) {
    [self.output correctPassword:password];
  } else {
    [self.output incorrectPassword];
  }
}

@end
