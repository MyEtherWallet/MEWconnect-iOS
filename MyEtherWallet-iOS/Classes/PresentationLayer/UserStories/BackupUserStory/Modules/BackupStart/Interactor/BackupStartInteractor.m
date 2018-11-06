//
//  BackupStartInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "MEWwallet.h"

#import "BackupStartInteractor.h"

#import "BackupStartInteractorOutput.h"

#import "MEWwallet.h"

#import "AccountPlainObject.h"

@interface BackupStartInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@end

@implementation BackupStartInteractor

#pragma mark - BackupStartInteractorInput

- (void) configurateWithAccount:(AccountPlainObject *)account {
  self.account = account;
}

- (void) passwordDidEntered:(NSString *)password {
  NSArray *mnemonics = [self.walletService recoveryMnemonicsWordsWithPassword:password ofAccount:self.account];
  [self.output mnemonicsDidReceived:mnemonics];
}

- (AccountPlainObject *)obtainAccount {
  return self.account;
}

@end
