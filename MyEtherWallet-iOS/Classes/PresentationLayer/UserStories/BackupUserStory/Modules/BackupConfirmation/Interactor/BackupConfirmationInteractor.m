//
//  BackupConfirmationInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationInteractor.h"

#import "BackupConfirmationInteractorOutput.h"

#import "AccountsService.h"
#import "SecurityService.h"
#import "MEWwallet.h"

#import "BackupConfirmationQuiz.h"

@interface BackupConfirmationInteractor ()
@property (nonatomic, strong) AccountPlainObject *account;
@property (nonatomic, strong) BackupConfirmationQuiz *quiz;
@property (nonatomic, strong) NSArray <NSString *> *mnemonics;
@end

@implementation BackupConfirmationInteractor

#pragma mark - BackupConfirmationInteractorInput

- (void) configurateWithMnemonics:(NSArray <NSString *> *)mnemonics ofAccount:(AccountPlainObject *)account {
  _account = account;
  _mnemonics = mnemonics;
}

- (BackupConfirmationQuiz *) obtainRecoveryQuiz {
  if (!_quiz) {
    NSArray *allWords = [self.walletService obtainBIP32Words];
    _quiz = [[BackupConfirmationQuiz alloc] initWithWords:allWords
                                             correctWords:self.mnemonics
                                                 quizSize:4
                                             questionSize:3];
  }
  return _quiz;
}

- (void) checkVector:(NSArray <NSString *> *)vector {
  [self.output vectorDidChecked:[self.quiz checkVector:vector]];
}

- (void) walletBackedUp {
  [self.accountsService accountBackedUp:self.account];
}

- (void) enableSecurityProtection {
  [self.securityService enableForceProtection];
}

- (void) disableSecurityProtection {
  [self.securityService disableForceProtection];
}

@end
