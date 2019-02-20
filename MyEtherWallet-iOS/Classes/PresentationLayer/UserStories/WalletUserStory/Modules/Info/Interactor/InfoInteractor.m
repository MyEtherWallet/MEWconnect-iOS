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
#import "Ponsomizer.h"

#import "AccountPlainObject.h"
#import "NetworkPlainObject.h"
#import "TokenPlainObject.h"

@interface InfoInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@end

@implementation InfoInteractor

#pragma mark - InfoInteractorInput

- (void) configureWithAccount:(AccountPlainObject *)account {
  self.account = account;
}

- (void) accountBackedUp {
  AccountModelObject *accountModelObject = [self.accountsService obtainAccountWithAccount:self.account];
  NSArray *ignoringProperties = @[NSStringFromSelector(@selector(tokens)),
                                  NSStringFromSelector(@selector(purchaseHistory))];
  
  self.account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
}

- (AccountPlainObject *) obtainAccount {
  return self.account;
}

- (BOOL) isBackupAvailable {
  return [self.walletService isSeedAvailableForAccount:self.account];
}

- (BOOL) isBackedUp {
  return [self.account.backedUp boolValue];
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
