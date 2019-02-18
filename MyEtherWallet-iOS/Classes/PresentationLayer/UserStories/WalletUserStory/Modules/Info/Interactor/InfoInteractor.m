//
//  InfoInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/06/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "InfoInteractor.h"

#import "InfoInteractorOutput.h"

#import "AccountsService.h"
#import "KeychainService.h"
#import "TokensService.h"
#import "MEWwallet.h"

@interface InfoInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@end

@implementation InfoInteractor

#pragma mark - InfoInteractorInput

- (void) configureWithAccount:(AccountPlainObject *)account {
  self.account = account;
}

- (AccountPlainObject *) obtainAccount {
  return self.account;
}

- (void) resetWallet {
  [self.accountsService resetAccounts];
  [self.tokensService resetTokens];
  [self.keychainService resetKeychain];
}

- (void) passwordDidEntered:(NSString *)password {
  NSArray <NSString *> *mnemonics = [self.walletService recoveryMnemonicsWordsWithPassword:password ofAccount:self.account];
  [self.output mnemonicsDidReceived:mnemonics];
}

@end
