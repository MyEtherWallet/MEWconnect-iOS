//
//  ForgotPasswordInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 27/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "ForgotPasswordInteractor.h"

#import "ForgotPasswordInteractorOutput.h"

#import "AccountsService.h"
#import "KeychainService.h"

@interface ForgotPasswordInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@end

@implementation ForgotPasswordInteractor

#pragma mark - ForgotPasswordInteractorInput

- (void)configurateWithAccount:(AccountPlainObject *)account {
  _account = account;
}

- (void) resetWallet {
  [self.accountsService resetAccounts];
  [self.keychainService resetKeychain];
}

@end
