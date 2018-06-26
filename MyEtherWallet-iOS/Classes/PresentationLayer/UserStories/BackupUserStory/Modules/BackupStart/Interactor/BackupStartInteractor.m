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

@implementation BackupStartInteractor

#pragma mark - BackupStartInteractorInput

- (void) passwordDidEntered:(NSString *)password {
  NSArray *mnemonics = [self.walletService recoveryMnemonicsWordsWithPassword:password];
  [self.output mnemonicsDidReceived:mnemonics];
}

@end
