//
//  BackupConfirmationInteractorInput.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@class BackupConfirmationQuiz;
@class AccountPlainObject;

@protocol BackupConfirmationInteractorInput <NSObject>
- (void) configurateWithMnemonics:(NSArray <NSString *> *)mnemonics ofAccount:(AccountPlainObject *)account;
- (BackupConfirmationQuiz *) obtainRecoveryQuiz;
- (void) checkVector:(NSArray <NSString *> *)vector;
- (void) walletBackedUp;
- (void) enableSecurityProtection;
- (void) disableSecurityProtection;
@end
