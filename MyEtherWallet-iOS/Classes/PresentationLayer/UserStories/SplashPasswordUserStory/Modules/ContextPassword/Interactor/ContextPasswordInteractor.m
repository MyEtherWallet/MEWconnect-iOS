//
//  ContextPasswordInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 11/09/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ContextPasswordInteractor.h"

#import "AccountsService.h"
#import "MEWwallet.h"
#import "Ponsomizer.h"

#import "NetworkPlainObject.h"
#import "AccountPlainObject.h"

#import "ContextPasswordInteractorOutput.h"

@interface ContextPasswordInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@end

@implementation ContextPasswordInteractor

#pragma mark - ContextPasswordInteractorInput

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
